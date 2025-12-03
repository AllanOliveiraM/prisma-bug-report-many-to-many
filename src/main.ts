import "dotenv/config";

import { PrismaClient } from "@main-db/client";
import { PrismaPg } from "@prisma/adapter-pg";

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });

const prisma = new PrismaClient({
  adapter,

  log: [
    { emit: "stdout", level: "query" },
    { emit: "stdout", level: "info" },
    { emit: "stdout", level: "warn" },
    { emit: "stdout", level: "error" },
  ],
  errorFormat: "pretty",
});

// ? Start DB: docker compose -f ./docker-compose.dev.yml up
// ? Down DB: docker compose -f ./docker-compose.dev.yml down

async function main() {
  // 1) Create a Company just to satisfy FKs (simplified)
  const company = await prisma.company.upsert({
    create: {
      id: "grano",
      name: "Test Company",
      timezone: "America/Sao_Paulo",
      country: "BR",
      state: "RS",
      city: "Pelotas",
    },
    update: {},
    where: {
      id: "grano",
    },
  });

  // 2) Create a Producer
  const producer = await prisma.producer.create({
    data: {
      name: "Produtor 1",
      search_name: "Produtor 1",
      companyId: company.id,
    },
  });

  // 3) Create a TraceabilityTrackingOptions record
  const tto = await prisma.traceabilityTrackingOptions.upsert({
    where: {
      id: "TTO",
    },
    create: {
      id: "TTO",
      SystemCultureMode: "RICE_WHITE",
      companyId: company.id,
      DefaultProducerAttributions: {
        // try to connect on create as well
        connect: [{ id: producer.id }],
      },
    },
    update: {},
  });

  console.log("Created Producer id:", producer.id);
  console.log("Created TTO id:", tto.id);

  // 4) Update TTO using `set` to make it as explicit as possible
  const updated = await prisma.traceabilityTrackingOptions.update({
    where: { id: tto.id },
    data: {
      DefaultProducerAttributions: {
        set: [{ id: producer.id }],
      },
    },
    include: {
      DefaultProducerAttributions: true,
    },
  });

  console.log("Updated TTO (include DefaultProducerAttributions):");
  console.dir(updated, { depth: null });

  // 5) Read from the Producer side
  const fromProducer = await prisma.producer.findUnique({
    where: { id: producer.id },
    include: {
      TraceabilityTrackingOptions: true,
    },
  });

  console.log("Producer with TraceabilityTrackingOptions:");
  console.dir(fromProducer, { depth: null });

  // 6) Read from the TTO side again, just to be sure
  const fromTto = await prisma.traceabilityTrackingOptions.findUnique({
    where: { id: tto.id },
    include: {
      DefaultProducerAttributions: true,
    },
  });

  console.log("TTO with DefaultProducerAttributions (second read):");
  console.dir(fromTto, { depth: null });

  console.log('!! Update:')
  console.log(`
    Fixed in this versions:

    "@prisma/adapter-pg": "^7.1.0",
    "@prisma/client": "^7.1.0",
    "prisma": "^7.1.0"
    `)

}

main().finally(async () => {
  await prisma.$disconnect();
});
