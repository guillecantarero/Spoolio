import { useLayoutEffect, useMemo, useRef, useState } from 'react';
import { BobinaIcono } from './BobinaIcono';
import type { Filament } from './domain';

export function SpoolShelf({ filaments }: { filaments: Filament[] }) {
  const container = useRef<HTMLDivElement>(null);
  const [space, setSpace] = useState({ width: 0, height: 0 });
  const [seed] = useState(() => Math.random());
  const ordered = useMemo(() => {
    let random = Math.floor(seed * 2147483646) + 1;
    return filaments.map(f => { random = random * 16807 % 2147483647; return { f, order: random }; })
      .sort((a, b) => a.order - b.order).map(item => item.f);
  }, [filaments, seed]);
  useLayoutEffect(() => {
    const element = container.current;
    if (!element) return;
    const observer = new ResizeObserver(([entry]) => {
      const { width, height } = entry.contentRect;
      setSpace(previous => previous.width === width && previous.height === height ? previous : { width, height });
    });
    observer.observe(element);
    return () => observer.disconnect();
  }, []);
  const columns = Math.max(1, Math.ceil((space.width - 8) / 48));
  const rows = Math.floor(space.height / 92);
  const size = Math.max(0, (space.width - 8) / ((columns - 1) * 0.5 + 0.65));
  return <div ref={container} className="scan-shelves" aria-hidden="true">
    {ordered.length > 0 && Array.from({ length: rows }, (_, row) => <div className="scan-shelf" key={row} style={{ height: `${100 / rows}%` }}>
      {Array.from({ length: columns }, (_, column) => {
        const filament = ordered[(row * columns + column) % ordered.length];
        return <span className="shelf-spool" key={column} style={{ width: size * 0.5, zIndex: columns - column }}><BobinaIcono colores={filament.colors.map(c => c.hex)} translucido={filament.translucent} size={size} decorative/></span>;
      })}
    </div>)}
  </div>;
}
