import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Combines multiple class values into a single string using clsx and tailwind-merge.
 * This utility function helps manage dynamic class names and prevents Tailwind CSS conflicts.
 * 
 * @param inputs - Array of class values that can be strings, objects, arrays, etc.
 * @returns A merged string of class names with Tailwind conflicts resolved
 * 
 * @example
 * cn("px-2 py-1", condition && "bg-blue-500", { "text-white": isActive })
 * // Returns: "px-2 py-1 bg-blue-500 text-white" (when condition and isActive are true)
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/**
 * Detects if the code is running inside a Tauri environment.
 *
 * When the frontend is served standalone (e.g. with `bun run dev`) the
 * `window.__TAURI__` global is not available and calling Tauri APIs will
 * result in errors like `Cannot read properties of undefined (reading 'invoke')`.
 */
export function isTauri(): boolean {
  return typeof window !== "undefined" && Boolean((window as any).__TAURI__);
}
