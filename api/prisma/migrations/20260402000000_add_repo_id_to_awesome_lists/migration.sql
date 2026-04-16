-- AlterTable
ALTER TABLE "awesome_lists" ADD COLUMN "repo_id" INTEGER;

-- CreateIndex
CREATE INDEX "awesome_lists_repo_id_idx" ON "awesome_lists"("repo_id");

-- AddForeignKey
ALTER TABLE "awesome_lists" ADD CONSTRAINT "awesome_lists_repo_id_fkey" FOREIGN KEY ("repo_id") REFERENCES "repos"("id") ON DELETE SET NULL ON UPDATE CASCADE;
