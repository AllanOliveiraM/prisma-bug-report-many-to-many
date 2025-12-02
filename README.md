### Bug description

Hi Prisma team 👋

I'm facing a weird behavior with an **implicit many-to-many relation** in Prisma 7.0.1 using PostgreSQL:  
the join table row *exists*, one side of the relation works correctly with `include`, but the opposite side always returns an empty array.

It really looks like a mapping/implicit-M:N bug, so I wanted to report it with a minimal repro.

---

This is a standard implicit many-to-many between `Producer` and `TraceabilityTrackingOptions`.
Prisma generates the join table `_ProducerToTraceabilityTrackingOptions` (schema `public`) with columns `"A"` and `"B"`.

In the database, a typical row looks like:

* `A` = `cm7rrve4p0001flnzxm7h1p6s` (a `Producer.id`)
* `B` = `cmip0ihe00000gnflc6wt9eqs` (a `TraceabilityTrackingOptions.id`)

---
#### Problem introduction:

Reading from the **TraceabilityTrackingOptions** side (even right after the `update`) does **not**:

```ts
const updated = await prisma.traceabilityTrackingOptions.update({
    where: { id: 'cmip0ihe00000gnflc6wt9eqs' },
    data: {
    DefaultProducerAttributions: {
        set: [{ id: 'cm7rrve4p0001flnzxm7h1p6s' }],
    },
    },
    include: { DefaultProducerAttributions: true },
})

// updated.DefaultProducerAttributions === []  ❌ (unexpected)
```

And a subsequent `findUnique` with `include: { DefaultProducerAttributions: true }` also returns:

```json
"DefaultProducerAttributions": []
```

---

Thanks a lot for taking a look at this! 🙏

---
---


### Severity

🔹 Minor plus Major: Unexpected behavior, but does not block development, but production clients are noticing errors and trying to save again, and again...

### Reproduction

## Reproduction code

[Github Repo](https://github.com/AllanOliveiraM/prisma-bug-report-many-to-many)

> [src/main.ts](src/main.ts) content


```ts
import 'dotenv/config'

import { PrismaClient } from '@main-db/client'
import { PrismaPg } from '@prisma/adapter-pg'

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL })

const prisma = new PrismaClient({
  adapter,

  log: [
    { emit: 'stdout', level: 'query' },
    { emit: 'stdout', level: 'info' },
    { emit: 'stdout', level: 'warn' },
    { emit: 'stdout', level: 'error' },
  ],
  errorFormat: 'pretty',
})

async function main() {
  // 1) Create a Company just to satisfy FKs (simplified)
  const company = await prisma.company.create({
    data: {
      id: 'grano',
      name: 'Test Company',
      timezone: 'America/Sao_Paulo',
      country: 'BR',
      state: 'RS',
      city: 'Pelotas',
    },
  })

  // 2) Create a Producer
  const producer = await prisma.producer.create({
    data: {
      name: 'Produtor 1',
      search_name: 'Produtor 1',
      companyId: company.id,
    },
  })

  // 3) Create a TraceabilityTrackingOptions record
  const tto = await prisma.traceabilityTrackingOptions.create({
    data: {
      SystemCultureMode: 'RICE_WHITE',
      companyId: company.id,
      DefaultProducerAttributions: {
        // try to connect on create as well
        connect: [{ id: producer.id }],
      },
    },
  })

  console.log('Created Producer id:', producer.id)
  console.log('Created TTO id:', tto.id)

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
  })

  console.log('Updated TTO (include DefaultProducerAttributions):')
  console.dir(updated, { depth: null })

  // 5) Read from the Producer side
  const fromProducer = await prisma.producer.findUnique({
    where: { id: producer.id },
    include: {
      TraceabilityTrackingOptions: true,
    },
  })

  console.log('Producer with TraceabilityTrackingOptions:')
  console.dir(fromProducer, { depth: null })

  // 6) Read from the TTO side again, just to be sure
  const fromTto = await prisma.traceabilityTrackingOptions.findUnique({
    where: { id: tto.id },
    include: {
      DefaultProducerAttributions: true,
    },
  })

  console.log('TTO with DefaultProducerAttributions (second read):')
  console.dir(fromTto, { depth: null })
}

main().finally(async () => {
  await prisma.$disconnect()
})

```

### Expected vs. Actual Behavior

## Actual behavior

1. The join table has the expected row:

   ```sql
   SELECT * FROM "public"."_ProducerToTraceabilityTrackingOptions"
   WHERE "B" = 'cmip0ihe00000gnflc6wt9eqs';

   -- result:
   --  A                                   B
   --  cm7rrve4p0001flnzxm7h1p6s           cmip0ihe00000gnflc6wt9eqs
   ```

2. Reading from the **Producer** side works:

   ```ts
   const fromProducer = await prisma.producer.findUnique({
     where: { id: 'cm7rrve4p0001flnzxm7h1p6s' },
     include: { TraceabilityTrackingOptions: true },
   })

   // fromProducer.TraceabilityTrackingOptions.length === 1 ✅
   // and it contains the TTO with id 'cmip0ihe00000gnflc6wt9eqs'
   ```

3. Reading from the **TraceabilityTrackingOptions** side (even right after the `update`) does **not**:

   ```ts
   const updated = await prisma.traceabilityTrackingOptions.update({
     where: { id: 'cmip0ihe00000gnflc6wt9eqs' },
     data: {
       DefaultProducerAttributions: {
         set: [{ id: 'cm7rrve4p0001flnzxm7h1p6s' }],
       },
     },
     include: { DefaultProducerAttributions: true },
   })

   // updated.DefaultProducerAttributions === []  ❌ (unexpected)
   ```

   And a subsequent `findUnique` with `include: { DefaultProducerAttributions: true }` also returns:

   ```json
   "DefaultProducerAttributions": []
   ```

So:

* `Producer.TraceabilityTrackingOptions` sees the relation ✅
* `TraceabilityTrackingOptions.DefaultProducerAttributions` does **not**, and always comes back as an empty array ❌
* The join table row is definitely there in the DB.

---

## Additional notes

* I also tested an even more minimal update:

  ```ts
  await prisma.traceabilityTrackingOptions.update({
    where: { id: 'cmip0ihe00000gnflc6wt9eqs' },
    data: {
      DefaultProducerAttributions: { set: [{ id: 'cm7rrve4p0001flnzxm7h1p6s' }] },
    },
    include: { DefaultProducerAttributions: true },
  })
  ```

  and the behavior is the same: the `include` on `DefaultProducerAttributions` returns `[]`.

* There are no custom middlewares mutating the result, and the same database instance is used both by Prisma and by my SQL client (I double-checked by querying the IDs shown in the Prisma logs).

---

## Expected behavior

Given an implicit many-to-many relation:

```prisma
model TraceabilityTrackingOptions {
  DefaultProducerAttributions Producer[]
}

model Producer {
  TraceabilityTrackingOptions TraceabilityTrackingOptions[]
}
```

and a join row `(A = producer.id, B = traceabilityTrackingOptions.id)` in `_ProducerToTraceabilityTrackingOptions`, I would expect:

* `producer.TraceabilityTrackingOptions` to contain the related TTO ✅
* **and** `traceabilityTrackingOptions.DefaultProducerAttributions` to contain the related Producer ✅

Instead, only the `Producer` side works; the `TraceabilityTrackingOptions` side always comes back empty even though the join table row exists and the SQL Prisma runs for the include looks correct.


### Frequency

Consistently reproducible

### Does this occur in development or production?

Both development and production

### Is this a regression?

Crash in version >7.0.0

### Workaround

Creating explicit relation tables?

### Prisma Schema & Queries

> prisma/schema.prisma

```prisma
generator client {
  provider   = "prisma-client"
  output     = "./client"
  engineType = "client"
}

datasource db {
  provider = "postgresql"
}

model Company {
  id        String   @id @default(cuid())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  name     String
  timezone String
  country  String
  state    String
  city     String

  Producers                   Producer[]
  TraceabilityTrackingOptions TraceabilityTrackingOptions[]
}

model TraceabilityTrackingOptions {
  id        String   @id @default(cuid())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // other scalar fields omitted…

  /// This is the "default producers" relation
  DefaultProducerAttributions Producer[]

  SystemCultureMode SystemCultureMode @default(RICE_WHITE)

  Company   Company @relation(fields: [companyId], references: [id], onDelete: Cascade)
  companyId String

  @@unique([SystemCultureMode, companyId])
  @@index([createdAt])
}

model Producer {
  id        String   @id @default(cuid())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  isActive  Boolean  @default(true)

  name        String
  search_name String

  // other scalar fields omitted…

  /// Generic M:N relation to TraceabilityTrackingOptions
  TraceabilityTrackingOptions TraceabilityTrackingOptions[]

  Company   Company @relation(fields: [companyId], references: [id], onDelete: Cascade)
  companyId String

  @@index([createdAt])
}

enum SystemCultureMode {
  RICE_WHITE
  RICE_PARBO
}

```


---

## Logs & Debug Info

Below are the most relevant SQL queries from the Prisma logs when running the `update` with `include: { DefaultProducerAttributions: true }`:

> See [output-logs.sql](output-logs.sql)

### Prisma Config

```ts
import 'dotenv/config'
import type { PrismaConfig } from 'prisma'
import { env } from 'prisma/config'

export default {
  schema: 'prisma',
  migrations: {
    path: 'prisma/migrations',
  },
  datasource: {
    url: env('DATABASE_URL'),
  },
} satisfies PrismaConfig

```

### For context

```ts
import { Injectable, OnApplicationShutdown, OnModuleInit } from '@nestjs/common'

import { PrismaClient } from '@main-db/client'
import { PrismaPg } from '@prisma/adapter-pg'

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL })

@Injectable()
export class DatabaseService
  extends PrismaClient
  implements OnModuleInit, OnApplicationShutdown
{
  constructor() {
    const isDev = process.env.NODE_ENV === 'development'

    super({
      log: [
          ...(isDev
          ? [
              // TODO: Temp  
              {
                emit: 'stdout',
                level: 'query',
              },

              { emit: 'stdout' as const, level: 'info' as const },
              { emit: 'stdout' as const, level: 'warn' as const },
            ]
          : []),

        { emit: 'stdout', level: 'error' },
      ],
      errorFormat: isDev ? 'pretty' : 'colorless',
      adapter,
    })
  }

  async onModuleInit() {
    await this.$connect()
  }

  async onApplicationShutdown() {
    await this.$disconnect()
  }
}

```


### Environment & Setup

- Database: PostgreSQL 15
- OS: Ubuntu 25.04 | Any linux, tested 2
- Node.js: v22.19.0

### Prisma Version

- `@prisma/client`: 7.0.1
- `prisma`: 7.0.1
- `@prisma/adapter-pg`: 7.0.1
