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
    "startRecordingText",
    "stopRecording", 
    "stopRecordingWrapper",
    "processingWrapper",
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
    const ua = navigator.userAgent.toLowerCase()
    const isSafari = ua.includes("safari") && !ua.includes("chrome")

    // Safari to use MP4 or WAV, never WEBM which leads to errors
    if (isSafari) {
      if (MediaRecorder.isTypeSupported("audio/mp4")) return "audio/mp4"
      if (MediaRecorder.isTypeSupported("audio/wav")) return "audio/wav"
      return ""
    }

    // For Chrome, Firefox and Android
    if (MediaRecorder.isTypeSupported("audio/webm;codecs=opus")) return "audio/webm;codecs=opus"
    if (MediaRecorder.isTypeSupported("audio/ogg;codecs=opus"))  return "audio/ogg;codecs=opus"
    if (MediaRecorder.isTypeSupported("audio/mp4")) return "audio/mp4"
    if (MediaRecorder.isTypeSupported("audio/wav")) return "audio/wav"

    return ""
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
    this.chunks = []
  }

  async start(event) {
    event.preventDefault()
    // Implementation of start recording logic
    if (!navigator.mediaDevices || !window.MediaRecorder) return alert('Your browser does not support audio recording')

      // disable to avoid double clicks
      this.startRecordingTarget.disabled = true
      this.startRecordingTextTarget.classList.add("hidden")
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
          // hiding the buttons
          this.stopRecordingTarget.disabled = true
          this.startRecordingTarget.disabled = true
          this.stopRecordingWrapperTarget.classList.add("hidden")
          this.startRecordingWrapperTarget.classList.add("hidden")
          this.processingWrapperTarget.classList.remove("hidden")

          // process recording
          const blobType = this.chunks[0]?.type || this.supportedMime() || 'audio/mp4'
          const blob = new Blob(this.chunks, { type: blobType })
          this.chunks = []

          const ext = blob.type.split('/').shift() === 'audio' ? blob.type.split('/').pop().split(';')[0] : 'webm'
          const file = new File([blob], `recording-${Date.now()}.${ext}`, { type: blob.type })
          const dt = new DataTransfer()
          dt.items.add(file)
          this.fileInputTarget.files = dt.files

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