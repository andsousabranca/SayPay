import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recording"
export default class extends Controller {

  static targets = [ 
    "form", 
    "recordingStatus", 
    "recordingDot", 
    "recordingMessage", 
    "startRecording",
    "startRecordingWrapper",
    "stopRecording", 
    "stopRecordingWrapper",
    "fileInput" ]

  static values = {
    pingSound: String
  }

  mediaRecorder = null
  stream = null
  chunks = []
  recordTimer = null
  warmupTimer = null
  WARMUP_MS = 800 // short warmup delay (adjust as needed)
  MAX_MS = 60_000 // 60 seconds

  mimeCandidates = ['audio/webm;codecs=opus','audio/ogg;codecs=opus','audio/mp4','audio/wav']

  connect() {
    this.pingSound = new Audio(this.pingSoundValue)
  }

  supportedMime() {
    if (!window.MediaRecorder) return ''
    for (const c of this.mimeCandidates) {
      try { if (MediaRecorder.isTypeSupported && MediaRecorder.isTypeSupported(c)) return c } catch(e) {}
    }
    return ''
  }

  showStatus(msg, showDot = false) {
    this.recordingMessageTarget.textContent = msg
    this.recordingStatusTarget.classList.remove('hidden')
    if (showDot) this.recordingDotTarget.classList.remove('hidden')
    else this.recordingDotTarget.classList.add('hidden')
  }

  hideStatus() {
    this.recordingStatusTarget.classList.add('hidden')
    this.recordingDotTarget.classList.add('hidden')
    this.recordingMessageTarget.textContent = ''
  }

  resetUIAfterStop() {
    // re-enable and reset buttons/UI after form submits or stop
    this.startRecordingTarget.disabled = false
    this.startRecordingWrapperTarget.classList.remove('hidden')
    this.stopRecordingWrapperTarget.classList.add('hidden')
    this.stopRecordingTarget.disabled = true
    this.hideStatus()
    chunks = []
  }

  async start(event) {
    event.preventDefault()
    // Implementation of start recording logic
    if (!navigator.mediaDevices || !window.MediaRecorder) return alert('Your browser does not support audio recording')

      // disable to avoid double clicks
      this.startRecordingTarget.disabled = true
      this.showStatus('Initializing microphone...')

      this.stream = await navigator.mediaDevices.getUserMedia({ audio: true })

      // short warmup delay before starting the recording
      this.showStatus('Preparing... starting soon', false)
      this.warmupTimer = setTimeout(() => {
        // start real recording after a short warmup
        const mime = this.supportedMime()
        this.mediaRecorder = new MediaRecorder(this.stream, mime ? { mimeType: mime } : undefined)
        this.chunks = []

        this.mediaRecorder.ondataavailable = e => { if (e.data.size > 0) this.chunks.push(e.data) }
        this.mediaRecorder.onstop = () => {
          const blob = new Blob(this.chunks, { type: this.chunks[0]?.type || 'audio/webm' })
          this.chunks = []

          const ext = blob.type.split('/').shift() === 'audio' ? blob.type.split('/').pop().split(';')[0] : 'webm'
          const file = new File([blob], `recording-${Date.now()}.${ext}`, { type: blob.type })
          const dt = new DataTransfer()
          dt.items.add(file)
          this.fileInputTarget.files = dt.files

          // prevent additional interactions and submit
          this.stopRecordingTarget.disabled = true
          this.startRecordingTarget.disabled = true
          this.formTarget.submit()
        }

        this.mediaRecorder.start()

        // start playing ping sound to indicate recording started
        this.pingSound.currentTime = 0
        this.pingSound.play()

        // UI switch to actual recording state
        this.startRecordingWrapperTarget.classList.add('hidden')
        this.stopRecordingWrapperTarget.classList.remove('hidden')
        this.stopRecordingTarget.disabled = false
        this.showStatus('Recording — Speak now', true)

        // auto stop after max duration
        this.recordTimer = setTimeout(() => {
          if (this.mediaRecorder && this.mediaRecorder.state === 'recording') {
            this.mediaRecorder.stop()
            this.showStatus('Recording stopped automatically after 60s', false)
          }
        }, this.MAX_MS)
      }, this.WARMUP_MS)
  }

  stop(event) {
    event.preventDefault()
     // if warmup not finished, cancel warmup and reset UI
    if (this.warmupTimer) {
      clearTimeout(this.warmupTimer)
      this.warmupTimer = null
      if (this.stream) {
        this.stream.getTracks().forEach(t => t.stop())
        this.stream = null
      }
      this.resetUIAfterStop()
      return
    }

    if (this.recordTimer) {
      clearTimeout(this.recordTimer)
      this.recordTimer = null
    }
    if (this.mediaRecorder && this.mediaRecorder.state === 'recording') this.mediaRecorder.stop()
    if (this.stream) this.stream.getTracks().forEach(t => t.stop())
  }
}