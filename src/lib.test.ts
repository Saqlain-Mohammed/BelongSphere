import { describe, expect, it } from 'vitest';
import { filterItems, getBudget } from './lib';
import { items } from './data';
describe('discovery filtering',()=>{
 it('combines location and interests',()=>{const result=filterItems(items,'','Bengaluru','Flatmates',100000);expect(result.map(i=>i.id)).toEqual(['p1']);});
 it('extracts natural language budget limits',()=>{expect(getBudget('flatmates under ₹15,000')).toBe(15000);expect(getBudget('stays below 20k')).toBe(20000);expect(getBudget('a weekend trip')).toBeUndefined();});
 it('keeps free communities while enforcing budget',()=>{const result=filterItems(items,'','Bengaluru','All interests',1000);expect(result.some(i=>i.id==='c1')).toBe(true);expect(result.some(i=>i.id==='p1')).toBe(false);expect(result.some(i=>i.id==='e1')).toBe(true);});
 it('returns no results for unrelated queries',()=>{expect(filterItems(items,'astronomy','Everywhere','All interests',100000)).toHaveLength(0);});
 it('uses typed budgets instead of a default limit',()=>{expect(filterItems(items,'flatmates under 10k','Bengaluru','Flatmates',100000)).toHaveLength(0);});
});
