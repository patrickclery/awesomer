import { clampLimit } from '../trending.controller.js';

describe('clampLimit', () => {
  it.each([
    [undefined, 10],
    ['abc', 10],
    [0, 10],
    [-1, 10],
    ['-3', 10],
    [1, 1],
    ['7', 7],
    [2.9, 2],
    [50, 50],
    [500, 50],
  ])('WR-01: limit %p becomes %p', (input, expected) => {
    expect(clampLimit(input)).toBe(expected);
  });
});
