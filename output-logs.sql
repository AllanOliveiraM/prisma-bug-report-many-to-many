INSERT INTO "public"."Company" ("id","createdAt","updatedAt","name","timezone","country","state","city") VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING "public"."Company"."id", "public"."Company"."createdAt", "public"."Company"."updatedAt", "public"."Company"."name", "public"."Company"."timezone", "public"."Company"."country", "public"."Company"."state", "public"."Company"."city"
INSERT INTO "public"."Producer" ("id","createdAt","updatedAt","isActive","name","search_name","companyId") VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING "public"."Producer"."id", "public"."Producer"."createdAt", "public"."Producer"."updatedAt", "public"."Producer"."isActive", "public"."Producer"."name", "public"."Producer"."search_name", "public"."Producer"."companyId"
INSERT INTO "public"."TraceabilityTrackingOptions" ("id","createdAt","updatedAt","SystemCultureMode","companyId") VALUES ($1,$2,$3,CAST($4::text AS "public"."SystemCultureMode"),$5) RETURNING "public"."TraceabilityTrackingOptions"."id"
SELECT "public"."Producer"."id" FROM "public"."Producer" WHERE ("public"."Producer"."id" = $1 AND 1=1) OFFSET $2
INSERT INTO "public"."_ProducerToTraceabilityTrackingOptions" ("B","A") VALUES ($1,$2) ON CONFLICT DO NOTHING
SELECT "public"."TraceabilityTrackingOptions"."id", "public"."TraceabilityTrackingOptions"."createdAt", "public"."TraceabilityTrackingOptions"."updatedAt", "public"."TraceabilityTrackingOptions"."SystemCultureMode"::text, "public"."TraceabilityTrackingOptions"."companyId" FROM "public"."TraceabilityTrackingOptions" WHERE "public"."TraceabilityTrackingOptions"."id" = $1 LIMIT $2 OFFSET $3
COMMIT
-- Created Producer id: cmip6izdx0000flflhpdye5ch
-- Created TTO id: cmip6ize80001flfll8xtxlgv
SELECT "public"."TraceabilityTrackingOptions"."id", "public"."TraceabilityTrackingOptions"."createdAt", "public"."TraceabilityTrackingOptions"."updatedAt", "public"."TraceabilityTrackingOptions"."SystemCultureMode"::text, "public"."TraceabilityTrackingOptions"."companyId" FROM "public"."TraceabilityTrackingOptions" WHERE ("public"."TraceabilityTrackingOptions"."id" = $1 AND 1=1) LIMIT $2 OFFSET $3
SELECT "public"."Producer"."id", "t0"."B" AS "ProducerToTraceabilityTrackingOptions@TraceabilityTrackingOptions" FROM "public"."Producer" INNER JOIN "public"."_ProducerToTraceabilityTrackingOptions" AS "t0" ON "t0"."A" = "public"."Producer"."id" WHERE (1=1 AND "t0"."B" IN ($1)) OFFSET $2
DELETE FROM "public"."_ProducerToTraceabilityTrackingOptions" WHERE ("public"."_ProducerToTraceabilityTrackingOptions"."B" = ($1) AND "public"."_ProducerToTraceabilityTrackingOptions"."A" IN ($2))
SELECT "public"."Producer"."id" FROM "public"."Producer" WHERE ("public"."Producer"."id" = $1 AND 1=1) OFFSET $2
INSERT INTO "public"."_ProducerToTraceabilityTrackingOptions" ("B","A") VALUES ($1,$2) ON CONFLICT DO NOTHING
SELECT "public"."TraceabilityTrackingOptions"."id", "public"."TraceabilityTrackingOptions"."createdAt", "public"."TraceabilityTrackingOptions"."updatedAt", "public"."TraceabilityTrackingOptions"."SystemCultureMode"::text, "public"."TraceabilityTrackingOptions"."companyId" FROM "public"."TraceabilityTrackingOptions" WHERE "public"."TraceabilityTrackingOptions"."id" = $1 LIMIT $2 OFFSET $3
SELECT "public"."Producer"."id", "public"."Producer"."createdAt", "public"."Producer"."updatedAt", "public"."Producer"."isActive", "public"."Producer"."name", "public"."Producer"."search_name", "public"."Producer"."companyId", "t1"."B" AS "ProducerToTraceabilityTrackingOptions@TraceabilityTrackingOptions" FROM "public"."Producer" INNER JOIN "public"."_ProducerToTraceabilityTrackingOptions" AS "t1" ON "t1"."A" = "public"."Producer"."id" WHERE (1=1 AND "t1"."B" = $1) OFFSET $2
COMMIT
-- Updated TTO (include DefaultProducerAttributions):
-- {
--   id: 'cmip6ize80001flfll8xtxlgv',
--   createdAt: 2025-12-02T22:58:29.934Z,
--   updatedAt: 2025-12-02T22:58:29.934Z,
--   SystemCultureMode: 'RICE_WHITE',
--   companyId: 'grano',
--   DefaultProducerAttributions: []
-- }
SELECT "public"."Producer"."id", "public"."Producer"."createdAt", "public"."Producer"."updatedAt", "public"."Producer"."isActive", "public"."Producer"."name", "public"."Producer"."search_name", "public"."Producer"."companyId" FROM "public"."Producer" WHERE ("public"."Producer"."id" = $1 AND 1=1) LIMIT $2 OFFSET $3
SELECT "public"."TraceabilityTrackingOptions"."id", "public"."TraceabilityTrackingOptions"."createdAt", "public"."TraceabilityTrackingOptions"."updatedAt", "public"."TraceabilityTrackingOptions"."SystemCultureMode"::text, "public"."TraceabilityTrackingOptions"."companyId", "t0"."A" AS "ProducerToTraceabilityTrackingOptions@Producer" FROM "public"."TraceabilityTrackingOptions" INNER JOIN "public"."_ProducerToTraceabilityTrackingOptions" AS "t0" ON "t0"."B" = "public"."TraceabilityTrackingOptions"."id" WHERE (1=1 AND "t0"."A" = $1) OFFSET $2
-- Producer with TraceabilityTrackingOptions:
-- {
--   id: 'cmip6izdx0000flflhpdye5ch',
--   createdAt: 2025-12-02T22:58:29.925Z,
--   updatedAt: 2025-12-02T22:58:29.925Z,
--   isActive: true,
--   name: 'Produtor 1',
--   search_name: 'Produtor 1',
--   companyId: 'grano',
--   TraceabilityTrackingOptions: [
--     {
--       id: 'cmip6ize80001flfll8xtxlgv',
--       createdAt: 2025-12-02T22:58:29.934Z,
--       updatedAt: 2025-12-02T22:58:29.934Z,
--       SystemCultureMode: 'RICE_WHITE',
--       companyId: 'grano'
--     }
--   ]
-- }
SELECT "public"."TraceabilityTrackingOptions"."id", "public"."TraceabilityTrackingOptions"."createdAt", "public"."TraceabilityTrackingOptions"."updatedAt", "public"."TraceabilityTrackingOptions"."SystemCultureMode"::text, "public"."TraceabilityTrackingOptions"."companyId" FROM "public"."TraceabilityTrackingOptions" WHERE ("public"."TraceabilityTrackingOptions"."id" = $1 AND 1=1) LIMIT $2 OFFSET $3
SELECT "public"."Producer"."id", "public"."Producer"."createdAt", "public"."Producer"."updatedAt", "public"."Producer"."isActive", "public"."Producer"."name", "public"."Producer"."search_name", "public"."Producer"."companyId", "t0"."B" AS "ProducerToTraceabilityTrackingOptions@TraceabilityTrackingOptions" FROM "public"."Producer" INNER JOIN "public"."_ProducerToTraceabilityTrackingOptions" AS "t0" ON "t0"."A" = "public"."Producer"."id" WHERE (1=1 AND "t0"."B" = $1) OFFSET $2
-- TTO with DefaultProducerAttributions (second read):
-- {
--   id: 'cmip6ize80001flfll8xtxlgv',
--   createdAt: 2025-12-02T22:58:29.934Z,
--   updatedAt: 2025-12-02T22:58:29.934Z,
--   SystemCultureMode: 'RICE_WHITE',
--   companyId: 'grano',
--   DefaultProducerAttributions: []
-- }
