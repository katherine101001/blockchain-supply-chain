# 🔗 Blockchain Supply Chain Traceability

> **End-to-end product traceability on Ethereum Sepolia** — FYP · Full-stack Web3 application with cross-platform mobile client

---

## 🧱 System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     System Architecture                         │
├──────────────┬──────────────────────┬───────────────────────────┤
│   Flutter    │   FastAPI Backend    │    Ethereum (Sepolia)     │
│   Mobile     │   (Render Cloud)     │                           │
│              │                      │   SupplyChainRegistry     │
│  BLoC State  │  CRUD -> Service ->  │   Smart Contract          │
│  GoRouter    │  Web3.py Client      │   recordHash (immutable)  │
│  Design Sys  │  SQLAlchemy ORM      │   getProduct() / addBatch │
│  Dio HTTP    │  Pydantic Schemas    │                           │
│              │                      │                           │
│  Android/iOS │  PostgreSQL          │   Sepolia Testnet         │
│  Web/Desktop │  (Supabase/Render)   │   (Infura/Alchemy RPC)    │
└──────────────┴──────────────────────┴───────────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Blockchain** | Web3.py · Solidity · Ethereum Sepolia Testnet |
| **Backend** | FastAPI · SQLAlchemy 2.0 · Pydantic v2 · Uvicorn |
| **Database** | PostgreSQL (Supabase connection pooling / Render) |
| **Mobile** | Flutter 3.x (Dart) — Android, iOS, Web, Desktop |
| **State Mgmt** | BLoC pattern with streams |
| **Routing** | GoRouter — declarative, deep-linkable navigation |
| **HTTP Client** | Dio — interceptors, 60s timeout for Render cold starts |
| **Design System** | Custom component library (`design_system/`) |
| **Verification** | Etherscan WebView in-app tx verification |
| **Deployment** | Render (backend) · environment-variable secrets mgmt |

---

## ✨ Key Features

### 🔗 Immutable On-Chain Traceability
Every product's critical data is hashed (`recordHash`) and permanently stored on the Ethereum Sepolia blockchain via the `SupplyChainRegistry` smart contract. Once written, the record is **tamper-proof and publicly verifiable** — no one can rewrite supply chain history.

### 📱 Cross-Platform Flutter App
- **Single codebase** -> 4 platforms (Android, iOS, Web, Desktop)
- **BLoC architecture** — clean separation of UI, business logic, and data layers
- **GoRouter** — type-safe deep linking: `/product/:sku`, `/product/:sku/details`, `/product/:sku/real`
- **Custom design system** — `design_system/components/` with card variants (ModernMetricCard, ProductScanCard, StatCard, RecentItemCard), button variants (Primary, Icon, MiniAction), spacing tokens
- **Etherscan WebView** — one-tap on-chain transaction verification inside the app

### 🔍 Trace API with Real-Time Verification
- `GET /product/{sku}?full=true&verify=true` — full product data + on-chain verified trace logs
- `GET /product/{sku}/trace?verify=true` — trace history with live blockchain cross-check
- `GET /product/{sku}/latest` — latest status snapshot with optional verification
- All endpoints support the `verify` flag for real-time on-chain integrity checks

### 🛡️ Blockchain Integrity Layer
- **Dual verification**: database `record_hash` <-> smart contract `recordHash` cross-check
- **`verify_tx_on_chain()`** — validates transaction receipts against the Ethereum node
- **`get_onchain_recordHash()`** — reads the immutable hash directly from the smart contract
- Complete audit trail: `tx_hash`, `block_number`, `network`, `wallet_address`, `gas_used`, `gas_price`, `tx_cost_wei`

### 📦 Batch Upload System
- Seed data scripts (`upload_products.py`) with blockchain batch registration
- Post-upload verification (`verify_products.py`) for integrity confirmation
- `blockchain_upload_logs` table tracking every on-chain write

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/health` | Health check |
| `GET` | `/product/{sku}` | Basic product info |
| `GET` | `/product/{sku}?full=true&verify=true` | Full product + verified trace logs |
| `GET` | `/product/{sku}/trace` | Trace log history (with date/status filters) |
| `GET` | `/product/{sku}/trace?verify=true` | Trace log with on-chain verification |
| `GET` | `/product/{sku}/latest` | Latest blockchain status snapshot |

---

## 🗄️ Database Schema

### `products` — Supply Chain Master Data

| Field | Description |
|-------|------------|
| `sku` (PK) | Universal product identifier |
| `product_type`, `price`, `availability` | Core product info |
| `num_products_sold`, `revenue_generated` | Sales metrics |
| `stock_levels`, `lead_times`, `order_quantities` | Inventory |
| `shipping_times`, `shipping_carriers`, `shipping_costs` | Logistics |
| `supplier_name`, `location` | Sourcing |
| `production_volumes`, `manufacturing_lead_time`, `manufacturing_costs` | Manufacturing |
| `inspection_results`, `defect_rates` | Quality control |
| `transportation_modes`, `routes`, `costs` | Distribution |
| `record_hash` | On-chain immutable hash pointer |

### `blockchain_upload_logs` — Audit Trail

| Field | Description |
|-------|------------|
| `tx_hash`, `block_number` | Ethereum transaction reference |
| `network`, `wallet_address` | Blockchain network + signing wallet |
| `batch_number`, `num_records`, `skus` | Batch metadata |
| `gas_used`, `gas_price`, `tx_cost_wei` | Gas economics |
| `tx_status` | 1 = success, 0 = failure |

---

## 🗂️ Project Structure

```
blockchain-supply-chain/
├── backend/
│   ├── main.py                    # FastAPI app entry
│   ├── config.py                  # Env vars + DB engine (Supabase compat)
│   ├── blockchain/
│   │   ├── client.py              # Web3.py: contract + on-chain reads
│   │   └── transactions.py        # Transaction helpers
│   ├── crud/trace.py              # Database CRUD operations
│   ├── database/session.py        # SQLAlchemy session + Base
│   ├── models/models.py           # Product + BlockchainUploadLog ORM
│   ├── routes/trace.py            # REST: /product/{sku} endpoints
│   ├── schemas/schemas.py         # Pydantic: ProductFull, TraceLog, LatestStatus
│   ├── services/trace_service.py  # Business logic + blockchain verification
│   └── scripts/
│       ├── SupplyChainRegistry.json  # Smart contract ABI
│       ├── upload_products.py        # Seed + register on-chain
│       └── verify_products.py        # Integrity check
│
└── flutter/
    ├── app/
    │   ├── app.dart               # MaterialApp + providers
    │   ├── app_router.dart        # GoRouter: 6 routes + deep linking
    │   └── shell/                 # Bottom nav + app bar shell
    ├── core/
    │   ├── network/api_client.dart # Dio (60s timeout, interceptors)
    │   ├── services/              # SharedPreferences
    │   └── utils/                 # Logger, size utils, extensions
    ├── design_system/
    │   └── components/
    │       ├── buttons/           # Primary, Icon, MiniAction
    │       └── cards/             # StatCard, ProductScanCard, ModernMetricCard
    └── features/
        ├── product/               # Product detail pages
        └── webview/               # Etherscan tx verification
```

---

## 🚀 Getting Started

```bash
# Backend
cd backend
pip install -r requirements.txt
cp .env.example .env   # Set: SEPOLIA_RPC_URL, CONTRACT_ADDRESS, PRIVATE_KEY, DB_URL
uvicorn app.main:app --reload        # -> http://localhost:8000

# Flutter
cd flutter
flutter pub get && flutter run       # -> Connected device / emulator

# Seed + Verify
python backend/app/scripts/upload_products.py
python backend/app/scripts/verify_products.py
```

---

## 🔐 Smart Contract (Sepolia)

`SupplyChainRegistry.sol` deployed on Ethereum Sepolia testnet:
- `addProduct(sku, recordHash)` — register product hash on-chain
- `getProduct(sku)` — retrieve immutable record hash
- `addBatch(skus[], recordHashes[])` — batch registration for gas efficiency

ABI: `backend/scripts/SupplyChainRegistry.json`

---

<p align="center">
  <i>FastAPI · Web3.py · Flutter · PostgreSQL · Ethereum</i>
</p>
