import { migrateFilamentNames } from './filamentNames';
import { applyCommand, emptyState, type Command, type Filament, type State } from './domain';

const KEY = 'spoolio.demo.v1';
export interface Repository { read(): State | Promise<State>; execute(command: Command, actorId: string, expected?: Filament | null): Promise<State> }
export class LocalDemoRepository implements Repository {
  constructor(private storage: Pick<Storage, 'getItem' | 'setItem'>) {}
  read(): State {
    const raw = this.storage.getItem(KEY);
    if (!raw) return emptyState();
    try {
      const data = JSON.parse(raw);
      if (data.schema !== 1 || !['users', 'places', 'filaments', 'spools', 'events'].every(k => Array.isArray(data[k]))) throw new Error();
      // Compatible migration: legacy filaments render opaque; saved on the next write.
      data.filaments = data.filaments.map((f: State['filaments'][number]) => migrateFilamentNames({ ...f, translucent: typeof f.translucent === 'boolean' ? f.translucent : false }));
      // One-time visual-demo upgrade. Preserve any unit edited by the user.
      if (!data.visualDemoAmountsV1) {
        let index = 0;
        data.spools = data.spools.map((spool: State['spools'][number]) => {
          if (spool.demoSet !== 'visual-svg-v1') return spool;
          const amount = (['≤100 %', '<75 %', '<50 %', '<25 %'] as const)[index++ % 4];
          return spool.version === 1 && spool.amount === '≤100 %' && !spool.retiredAt ? { ...spool, amount } : spool;
        });
        data.visualDemoAmountsV1 = true;
      }
      return data as State;
    } catch { throw new Error('No se pueden leer los datos locales. No se han sobrescrito. Conserva una copia antes de reparar el almacenamiento.'); }
  }
  async execute(command: Command, actorId: string): Promise<State> {
    const commit = () => {
      const next = applyCommand(this.read(), command, actorId);
      // Publish only after the complete snapshot has been persisted successfully.
      try { this.storage.setItem(KEY, JSON.stringify(next)); }
      catch { throw new Error('No se pudo guardar en este dispositivo. Comprueba el espacio y los permisos del navegador.'); }
      return next;
    };
    if (typeof navigator !== 'undefined' && navigator.locks) return navigator.locks.request(KEY, commit);
    throw new Error('Este entorno no permite guardado local seguro. Abre la aplicación en localhost con un navegador actualizado.');
  }
}
