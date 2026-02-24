-- CreateTable
CREATE TABLE "awesome_lists" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "github_repo" TEXT NOT NULL,
    "state" TEXT NOT NULL DEFAULT 'pending',
    "last_commit_at" TIMESTAMP(3),
    "skip_external_links" BOOLEAN NOT NULL DEFAULT true,
    "processing_started_at" TIMESTAMP(3),
    "processing_completed_at" TIMESTAMP(3),
    "last_synced_at" TIMESTAMP(3),
    "last_pushed_at" TIMESTAMP(3),
    "sync_threshold" INTEGER DEFAULT 10,
    "archived" BOOLEAN NOT NULL DEFAULT false,
    "archived_at" TIMESTAMP(3),
    "readme_content" TEXT,
    "sort_preference" TEXT NOT NULL DEFAULT 'stars',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "awesome_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" SERIAL NOT NULL,
    "awesome_list_id" INTEGER NOT NULL,
    "parent_id" INTEGER,
    "name" TEXT NOT NULL,
    "slug" TEXT,
    "repo_count" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category_items" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "github_repo" TEXT,
    "demo_url" TEXT,
    "primary_url" TEXT,
    "description" TEXT,
    "commits_past_year" INTEGER,
    "last_commit_at" TIMESTAMP(3),
    "stars" INTEGER,
    "category_id" INTEGER NOT NULL,
    "previous_stars" INTEGER,
    "github_description" TEXT,
    "stars_30d" INTEGER,
    "stars_90d" INTEGER,
    "star_history_fetched_at" TIMESTAMP(3),
    "repo_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "category_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "repos" (
    "id" SERIAL NOT NULL,
    "github_repo" TEXT NOT NULL,
    "description" TEXT,
    "stars" INTEGER,
    "previous_stars" INTEGER,
    "last_commit_at" TIMESTAMP(3),
    "stars_7d" INTEGER,
    "stars_30d" INTEGER,
    "stars_90d" INTEGER,
    "star_history_fetched_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "repos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "star_snapshots" (
    "id" SERIAL NOT NULL,
    "repo_id" INTEGER NOT NULL,
    "stars" INTEGER NOT NULL,
    "snapshot_date" DATE NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "star_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "featured_profiles" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "avatar_url" TEXT,
    "bio" TEXT,
    "github_handle" TEXT,
    "twitter_handle" TEXT,
    "website" TEXT,
    "profile_type" TEXT NOT NULL,
    "awesome_list_id" INTEGER NOT NULL,
    "featured_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "featured_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "newsletter_subscribers" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "awesome_list_id" INTEGER NOT NULL,
    "subscribed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unsubscribed_at" TIMESTAMP(3),
    "confirmed" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "newsletter_subscribers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "newsletter_issues" (
    "id" SERIAL NOT NULL,
    "awesome_list_id" INTEGER NOT NULL,
    "subject" TEXT NOT NULL,
    "html_content" TEXT,
    "sent_at" TIMESTAMP(3),
    "issue_number" INTEGER NOT NULL,
    "trending_data_snapshot" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "newsletter_issues_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "repo_tags" (
    "id" SERIAL NOT NULL,
    "repo_id" INTEGER NOT NULL,
    "tag_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "repo_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sync_runs" (
    "id" SERIAL NOT NULL,
    "awesome_list_id" INTEGER NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'running',
    "items_synced" INTEGER NOT NULL DEFAULT 0,
    "error_message" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sync_runs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "awesome_lists_slug_key" ON "awesome_lists"("slug");

-- CreateIndex
CREATE INDEX "awesome_lists_archived_updated_at_idx" ON "awesome_lists"("archived", "updated_at");

-- CreateIndex
CREATE INDEX "awesome_lists_archived_idx" ON "awesome_lists"("archived");

-- CreateIndex
CREATE INDEX "awesome_lists_last_synced_at_idx" ON "awesome_lists"("last_synced_at");

-- CreateIndex
CREATE INDEX "awesome_lists_state_idx" ON "awesome_lists"("state");

-- CreateIndex
CREATE UNIQUE INDEX "categories_slug_key" ON "categories"("slug");

-- CreateIndex
CREATE INDEX "categories_awesome_list_id_idx" ON "categories"("awesome_list_id");

-- CreateIndex
CREATE INDEX "categories_parent_id_idx" ON "categories"("parent_id");

-- CreateIndex
CREATE INDEX "category_items_category_id_idx" ON "category_items"("category_id");

-- CreateIndex
CREATE INDEX "category_items_repo_id_idx" ON "category_items"("repo_id");

-- CreateIndex
CREATE INDEX "category_items_stars_previous_stars_idx" ON "category_items"("stars", "previous_stars");

-- CreateIndex
CREATE UNIQUE INDEX "repos_github_repo_key" ON "repos"("github_repo");

-- CreateIndex
CREATE INDEX "star_snapshots_repo_id_idx" ON "star_snapshots"("repo_id");

-- CreateIndex
CREATE INDEX "star_snapshots_snapshot_date_idx" ON "star_snapshots"("snapshot_date");

-- CreateIndex
CREATE UNIQUE INDEX "star_snapshots_repo_id_snapshot_date_key" ON "star_snapshots"("repo_id", "snapshot_date");

-- CreateIndex
CREATE INDEX "featured_profiles_awesome_list_id_idx" ON "featured_profiles"("awesome_list_id");

-- CreateIndex
CREATE INDEX "featured_profiles_is_active_idx" ON "featured_profiles"("is_active");

-- CreateIndex
CREATE INDEX "newsletter_subscribers_awesome_list_id_idx" ON "newsletter_subscribers"("awesome_list_id");

-- CreateIndex
CREATE UNIQUE INDEX "newsletter_subscribers_email_awesome_list_id_key" ON "newsletter_subscribers"("email", "awesome_list_id");

-- CreateIndex
CREATE INDEX "newsletter_issues_awesome_list_id_idx" ON "newsletter_issues"("awesome_list_id");

-- CreateIndex
CREATE UNIQUE INDEX "newsletter_issues_awesome_list_id_issue_number_key" ON "newsletter_issues"("awesome_list_id", "issue_number");

-- CreateIndex
CREATE UNIQUE INDEX "tags_name_key" ON "tags"("name");

-- CreateIndex
CREATE UNIQUE INDEX "tags_slug_key" ON "tags"("slug");

-- CreateIndex
CREATE INDEX "repo_tags_repo_id_idx" ON "repo_tags"("repo_id");

-- CreateIndex
CREATE INDEX "repo_tags_tag_id_idx" ON "repo_tags"("tag_id");

-- CreateIndex
CREATE UNIQUE INDEX "repo_tags_repo_id_tag_id_key" ON "repo_tags"("repo_id", "tag_id");

-- CreateIndex
CREATE INDEX "sync_runs_awesome_list_id_idx" ON "sync_runs"("awesome_list_id");

-- CreateIndex
CREATE INDEX "sync_runs_status_idx" ON "sync_runs"("status");

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_awesome_list_id_fkey" FOREIGN KEY ("awesome_list_id") REFERENCES "awesome_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_items" ADD CONSTRAINT "category_items_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_items" ADD CONSTRAINT "category_items_repo_id_fkey" FOREIGN KEY ("repo_id") REFERENCES "repos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "star_snapshots" ADD CONSTRAINT "star_snapshots_repo_id_fkey" FOREIGN KEY ("repo_id") REFERENCES "repos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "featured_profiles" ADD CONSTRAINT "featured_profiles_awesome_list_id_fkey" FOREIGN KEY ("awesome_list_id") REFERENCES "awesome_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "newsletter_subscribers" ADD CONSTRAINT "newsletter_subscribers_awesome_list_id_fkey" FOREIGN KEY ("awesome_list_id") REFERENCES "awesome_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "newsletter_issues" ADD CONSTRAINT "newsletter_issues_awesome_list_id_fkey" FOREIGN KEY ("awesome_list_id") REFERENCES "awesome_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "repo_tags" ADD CONSTRAINT "repo_tags_repo_id_fkey" FOREIGN KEY ("repo_id") REFERENCES "repos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "repo_tags" ADD CONSTRAINT "repo_tags_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tags"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sync_runs" ADD CONSTRAINT "sync_runs_awesome_list_id_fkey" FOREIGN KEY ("awesome_list_id") REFERENCES "awesome_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
