import { PrismaClient } from '@prisma/client';
import * as fs from 'fs';
import * as path from 'path';

const prisma = new PrismaClient();

const CSV_PATH = path.join(__dirname, '..', 'data', 'medicaments.csv');
const BATCH_SIZE = 2000;

function randomQuantity(): number {
  return Math.floor(Math.random() * 201); // 0-200 inclusive
}

async function main() {
  const existing = await prisma.reference.count();
  if (existing > 0) {
    console.log(`reference table already has ${existing} rows — skipping seed.`);
    return;
  }

  const raw = fs.readFileSync(CSV_PATH, 'utf-8');
  const lines = raw.split('\n').filter((l) => l.trim().length > 0);

  let batch: { cip7: string; cip13: string; name: string; quantity: number }[] = [];
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
      const result = await prisma.reference.createMany({ data: batch, skipDuplicates: true });
      totalInserted += result.count;
      batch = [];
    }
  }
  if (batch.length > 0) {
    const result = await prisma.reference.createMany({ data: batch, skipDuplicates: true });
    totalInserted += result.count;
  }

  console.log(`Seed complete: inserted ${totalInserted} reference rows.`);
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
