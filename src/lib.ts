import { createClient } from '@supabase/supabase-js';
import type { Item } from './data';
const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY;
export const supabase = url && key ? createClient(url, key) : null;
export function readLocal<T>(key: string, fallback: T): T { try { return JSON.parse(localStorage.getItem(key) || 'null') ?? fallback; } catch { return fallback; } }
export function writeLocal(key: string, value: unknown) { try { localStorage.setItem(key, JSON.stringify(value)); } catch { /* Private browsing can disable storage. */ } }
export function matches(item: Item, query: string) {
 const words = query.toLowerCase().replace(/[^a-z0-9\s]/g,'').split(/\s+/).filter(w => w.length > 2 && !['find','with','for','and','the','who','want','looking','people','near','under','budget'].includes(w) && !/^\d+$/.test(w));
 const text = `${item.title} ${item.subtitle} ${item.tags.join(' ')} ${item.city} ${item.area} ${item.description}`.toLowerCase();
 return !words.length || words.some(word => text.includes(word));
}
export function getBudget(query: string): number | undefined { const m=query.match(/(?:under|below|budget|max)\s*(?:₹|rs\.?\s*)?([\d,]+)\s*(k)?/i); return m ? Number(m[1].replaceAll(',','')) * (m[2] ? 1000 : 1) : undefined; }
export function filterItems(items: Item[], query: string, city: string, category: string, budget: number) {
 const max = getBudget(query) ?? budget;
 return items.filter(item => (city==='Everywhere' || item.city===city) && (category==='All interests' || item.tags.includes(category) || item.category===category) && (!item.price || item.price<=max) && matches(item,query));
}
