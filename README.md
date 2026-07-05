# MediLogix

MediLogix is a proof of concept for digitizing hospital pharmacy inventory management — from receiving medical supplies to delivering prepared orders to the operating room.

## Overview

Hospital pharmacies handle large volumes of medications and equipment that are traditionally tracked manually. MediLogix lets pharmacists scan incoming supplies with a mobile app, store them in known locations, and visualize the entire inventory (room, shelf, quantity) on an interactive map in a web app. It also streamlines ordering: pharmacists can order from external suppliers, and doctors can request supply "baskets" that pharmacists prepare ahead of medical procedures.

## Workflow

1. **Receiving** — Incoming medications and tools are scanned via barcode using the mobile app.
2. **Storage** — Items are stored in their designated locations within the pharmacy.
3. **Tracking** — The web app's interactive map shows which room an item is stored in, down to the exact shelf/storage unit, along with the quantity available.
4. **Supplier orders** — Pharmacists order medications and equipment from external suppliers.
5. **Doctor requests** — Doctors submit supply baskets to pharmacists, who prepare the orders ahead of medical procedures.
6. **Delivery** — Prepared baskets are delivered by hospital staff to the operating room or a designated drop-off area.

## Tech stack

| Component | Technology |
| --- | --- |
| API | [NestJS](https://nestjs.com/) + [Prisma](https://www.prisma.io/) ORM |
| Web app | [Angular](https://angular.dev/) + TailwindCSS |
| Mobile scanning app | [Flutter](https://flutter.dev/) |
| Database | PostgreSQL |

Additional building blocks: JWT (RS256) authentication, Swagger API docs, and WebSockets for realtime updates.

## Project structure

```text
MediLogix/
├── api/              # NestJS backend (Prisma + PostgreSQL, JWT auth, Swagger, WebSockets)
├── front-pharma/     # Angular web app (pharmacy map, orders, baskets)
├── mobile/           # Flutter app for barcode/QR scanning
├── .devcontainer/    # VS Code Dev Container: spins up api + front-pharma + PostgreSQL + pgAdmin
├── GITFLOW.md        # Branch model & Conventional Commits convention
└── LICENSE           # MIT
```

## Getting started (recommended: Dev Container)

The fastest way to run the full stack (API + web app + PostgreSQL + pgAdmin) is via the included VS Code Dev Container.

**Prerequisites:** [Docker](https://www.docker.com/) and VS Code with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

1. Clone the repository and open it in VS Code.
2. Run **"Dev Containers: Reopen in Container"** from the command palette.
3. On first boot, `post-create.sh` installs dependencies for `api` and `front-pharma`, generates a JWT RSA keypair, and runs Prisma migrations. `post-start.sh` then starts both dev servers automatically.

Once running:

| Service | URL |
| --- | --- |
| API | [localhost:3000](http://localhost:3000) |
| API docs (Swagger) | [localhost:3000/api](http://localhost:3000/api) |
| Web app (Angular) | [localhost:4200](http://localhost:4200) |
| pgAdmin | [localhost:5050](http://localhost:5050) |
| PostgreSQL | `localhost:5433` |

The mobile app is not part of the Dev Container and must be run manually (see below).

## Getting started (manual setup)

### API

```bash
cd api
npm install
# configure api/.env (see api/.env.txt), including DATABASE_URL pointing to your PostgreSQL instance
npx prisma generate
npx prisma migrate deploy
npm run start:dev
```

### Web app

```bash
cd front-pharma
npm install
# configure src/environments/environment.ts (see environment.ts.dist), pointing to your API URL
npm start
```

### Mobile app

```bash
cd mobile
cp .env.sample .env
flutter pub get
# start an emulator or connect a device
flutter run
```

A PostgreSQL instance must be reachable for the API (either via the Dev Container's `db` service or your own).

## Contributing

See [GITFLOW.md](./GITFLOW.md) for the branch model (`development` → `staging` → `main`) and the Conventional Commits convention used across the monorepo.

## License

This project is licensed under the [MIT License](./LICENSE).
