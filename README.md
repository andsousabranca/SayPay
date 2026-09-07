# SayPay 🎙️💸

**Voice-powered expense tracker for budget-conscious travellers.**

SayPay lets you log travel expenses hands-free — just tap a button and say
"I spent 20 euros on lunch." The app uses AI to parse your voice input and
instantly records the expense against your trip budget, so you always know
where your money is going.

## Live Demo
👉 https://saypay-pke.sliplane.app/

## Screenshots
<img width="663" height="836" alt="image" src="https://github.com/user-attachments/assets/6b4573cb-e15d-485e-873b-5268165fe36c" />
<img width="668" height="850" alt="image" src="https://github.com/user-attachments/assets/fed31c96-08a9-4fbb-b8bb-92c44b3c2a43" />

## Features
- **Voice expense logging** — speak naturally, AI extracts the amount,
  category, and description automatically
- **Trip budgets** — create a trip, set a budget, track spending in real time
- **Expense dashboard** — charts showing spending by category, daily trends,
  and budget remaining
- **Multi-currency support** — handles different currencies for international travel
- **Destination photos** — automatic trip imagery via Unsplash API

## Tech Stack
| Layer | Technology |
|---|---|
| Backend | Ruby on Rails 7.1 |
| AI / NLP | ruby_llm (LLM integration) |
| Audio | Cloudinary (voice recording storage) |
| Real-time | Hotwire (Turbo + Stimulus), Solid Cable |
| Background jobs | Solid Queue |
| Frontend | JavaScript, Tailwind CSS |
| Charts | Chartkick + Groupdate |
| Auth | Devise |
| Database | PostgreSQL |
| Deployment | Docker + Sliplane |

## Getting Started

### Prerequisites
- Ruby 3.3.5
- PostgreSQL

### Setup
```bash
git clone https://github.com/pkeane93/SayPay_pke
cd SayPay_pke
bundle install
rails db:create db:migrate db:seed
rails server

Set up your .env file with:
OPENAI_API_KEY=...
CLOUDINARY_URL=...
UNSPLASH_ACCESS_KEY=...

Author

Built by Pierre Keane and Andreas Sousa Branca as a final project at Le Wagon Brussels (Batch #2097).

---
