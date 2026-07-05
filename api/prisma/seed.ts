import {
  PrismaClient,
  enum_hospital_role,
  enum_order_status,
} from '@prisma/client';
import * as argon2 from 'argon2';
import * as fs from 'fs';
import * as path from 'path';

const prisma = new PrismaClient();

const CSV_PATH = path.join(__dirname, '..', 'data', 'medicaments.csv');
const BATCH_SIZE = 2000;

// Dev accounts used to generate orders. All share the same password.
const SEED_PASSWORD = 'Password1&';
const SEED_USERS: { email: string; role: enum_hospital_role }[] = [
  { email: 'doctor1@medilogix.test', role: enum_hospital_role.Doctor },
  { email: 'doctor2@medilogix.test', role: enum_hospital_role.Doctor },
  { email: 'doctor3@medilogix.test', role: enum_hospital_role.Doctor },
  { email: 'doctor4@medilogix.test', role: enum_hospital_role.Doctor },
  { email: 'doctor5@medilogix.test', role: enum_hospital_role.Doctor },
  { email: 'pharmacist1@medilogix.test', role: enum_hospital_role.Pharmacist },
  { email: 'pharmacist2@medilogix.test', role: enum_hospital_role.Pharmacist },
  { email: 'pharmacist3@medilogix.test', role: enum_hospital_role.Pharmacist },
  { email: 'pharmacist4@medilogix.test', role: enum_hospital_role.Pharmacist },
  { email: 'pharmacist5@medilogix.test', role: enum_hospital_role.Pharmacist },
];

function randomQuantity(): number {
  return Math.floor(Math.random() * 201); // 0-200 inclusive
}

async function seedReferences() {
  const existing = await prisma.reference.count();
  if (existing > 0) {
    console.log(
      `reference table already has ${existing} rows — skipping reference seed.`,
    );
    return;
  }

  const raw = fs.readFileSync(CSV_PATH, 'utf-8');
  const lines = raw.split('\n').filter((l) => l.trim().length > 0);

  let batch: { cip7: string; cip13: string; name: string; quantity: number }[] =
    [];
  let totalInserted = 0;

  for (const line of lines) {
    const parts = line.split(';');
    if (parts.length < 3) continue;
    const [cip7, cip13, name] = parts;
    batch.push({
      cip7: cip7.trim(),
      cip13: cip13.trim(),
      name: name.trim(),
      quantity: randomQuantity(),
    });

    if (batch.length >= BATCH_SIZE) {
      const result = await prisma.reference.createMany({
        data: batch,
        skipDuplicates: true,
      });
      totalInserted += result.count;
      batch = [];
    }
  }
  if (batch.length > 0) {
    const result = await prisma.reference.createMany({
      data: batch,
      skipDuplicates: true,
    });
    totalInserted += result.count;
  }

  console.log(`Seed complete: inserted ${totalInserted} reference rows.`);
}

async function seedUsers() {
  const emails = SEED_USERS.map((u) => u.email);
  const existing = await prisma.user.count({
    where: { email: { in: emails } },
  });
  if (existing === SEED_USERS.length) {
    console.log(`Seed users already present (${existing}) — skipping.`);
    return;
  }

  const password = await argon2.hash(SEED_PASSWORD);
  for (const u of SEED_USERS) {
    await prisma.user.upsert({
      where: { email: u.email },
      update: {},
      create: { email: u.email, password, role: u.role },
    });
  }

  console.log(
    `Seeded ${SEED_USERS.length} Doctor/Pharmacist users (password: ${SEED_PASSWORD}).`,
  );
}

function pick<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

// Pick `count` distinct elements from `arr`.
function sampleDistinct<T>(arr: T[], count: number): T[] {
  const pool = [...arr];
  const out: T[] = [];
  while (out.length < count && pool.length > 0) {
    const idx = Math.floor(Math.random() * pool.length);
    out.push(pool.splice(idx, 1)[0]);
  }
  return out;
}

const ORDER_COUNT = 15;
const ORDER_STATUSES: enum_order_status[] = [
  enum_order_status.New,
  enum_order_status.Ongoing,
  enum_order_status.Ready,
  enum_order_status.Cancelled,
];

async function seedOrders() {
  const existing = await prisma.order.count();
  if (existing > 0) {
    console.log(`orders already present (${existing}) — skipping order seed.`);
    return;
  }

  const users = await prisma.user.findMany({
    where: { email: { in: SEED_USERS.map((u) => u.email) } },
    select: { id: true },
  });
  const refs = await prisma.reference.findMany({
    select: { id: true },
    take: 200,
    orderBy: { id: 'asc' },
  });
  if (users.length === 0 || refs.length === 0) {
    console.log('No seed users or references found — skipping order seed.');
    return;
  }

  for (let i = 0; i < ORDER_COUNT; i++) {
    const user = pick(users);
    const status = pick(ORDER_STATUSES);
    const lineCount = 2 + Math.floor(Math.random() * 3); // 2-4 distinct lines
    const lines = sampleDistinct(refs, lineCount).map((r) => ({
      reference_id: r.id,
      quantity: 1 + Math.floor(Math.random() * 50),
    }));

    await prisma.order.create({
      data: {
        user_id: user.id,
        status,
        references: { create: lines },
      },
    });
  }

  console.log(`Seeded ${ORDER_COUNT} orders with line items.`);
}

async function main() {
  await seedReferences();
  await seedUsers();
  await seedOrders();
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
