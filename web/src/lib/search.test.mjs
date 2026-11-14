// node --test web/src/lib/search.test.mjs
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { searchRepos } from './search.ts';

const index = {
  v: 1,
  lists: [
    ['mail', 'awesome-mail'],
    ['selfhosted', 'awesome-selfhosted']
  ],
  cats: [
    [0, 'Servers', 'servers'],
    [1, 'Communication', '']
  ],
  repos: [
    ['a/tie-b', null, 'mail tie', 50, 2, null, []],
    ['a/tie-a', null, 'mail tie', 50, 2, null, []],
    ['a/tie-hot', null, 'mail tie', 50, 9, null, []],
    ['a/tie-null', null, 'mail tie', null, null, null, []],
    ['a/tie-big', null, 'mail tie', 60, 0, null, []],
    ['x/mail', null, 'a mail thing', 10, null, null, [0]],
    ['y/mailcow', 'mailcow: dockerized', 'Mail server', 1000, 5, 30, [0, 1]],
    ['z/foo', 'Foo', 'Self-hosted mail stack', 5000, null, null, [1]],
    ['z/bar', 'Bar', 'Self hosted chat', 9000, null, null, []],
    ['q/hosted-mail-self', null, 'nothing', 1, null, null, []]
  ]
};

const names = (hits) => hits.map((h) => h.githubRepo);

test('name matches rank above description-only matches regardless of stars', () => {
  const order = names(searchRepos(index, 'mail'));
  assert.ok(order.indexOf('x/mail') < order.indexOf('y/mailcow'));
  assert.ok(order.indexOf('y/mailcow') < order.indexOf('z/foo'));
  assert.equal(order[0], 'x/mail');
});

test('every token must match; case-insensitive and trimmed', () => {
  assert.deepEqual(names(searchRepos(index, '  SELF   Hosted  MAIL ')).sort(), ['q/hosted-mail-self', 'z/foo']);
  assert.ok(!names(searchRepos(index, 'self hosted mail')).includes('z/bar'));
});

test('empty and whitespace-only queries return []', () => {
  assert.deepEqual(searchRepos(index, ''), []);
  assert.deepEqual(searchRepos(index, '   \t '), []);
});

test('equal tiers order by stars desc (null last), then stars7d desc, then githubRepo asc', () => {
  const order = names(searchRepos(index, 'tie'));
  assert.deepEqual(order, ['a/tie-big', 'a/tie-hot', 'a/tie-a', 'a/tie-b', 'a/tie-null']);
});

test('memberships resolve list and category names and slugs', () => {
  const hit = searchRepos(index, 'mailcow')[0];
  assert.equal(hit.githubRepo, 'y/mailcow');
  assert.deepEqual(hit.memberships, [
    { listSlug: 'mail', listName: 'awesome-mail', categoryName: 'Servers', categorySlug: 'servers' },
    { listSlug: 'selfhosted', listName: 'awesome-selfhosted', categoryName: 'Communication', categorySlug: '' }
  ]);
  assert.equal(hit.stars30d, 30);
});
