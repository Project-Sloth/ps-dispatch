import { writable, derived } from "svelte/store";

export const VISIBILITY = writable<boolean>(false);
export const BROWSER_MODE = writable<boolean>(false);
export const RESOURCE_NAME = writable<string>("");

export const PLAYER = writable<any>(null);
export const MAX_CALL_LIST = writable<number>(null);
export const RESPOND_KEYBIND = writable<string>("");

export const DISPATCH_MUTED = writable<boolean>(false);
export const DISPATCH_DISABLED = writable<boolean>(false);

export const DISPATCH = writable<any[]>(null);

export const IS_RIGHT_MARGIN = writable(true);

export const shortCalls = writable(true);

export function removeDispatch(callID) {
  DISPATCH.update(dispatches => {
    return dispatches.filter(dispatch => dispatch.data.id !== callID);
  });
}

interface DISPATCHMENU_DATA {
  id: number,
  message: string,
  code: string,
  icon: string,
  time: number,
  priority: number,
  street: string,
  coords: any[],
  gender: string,
  automaticGunFire: boolean,
  weapon: string,
  units: any[],
  name: string,
  number: string,
  information: string,
  vehicle: string,
  color: string,
  plate: string,
  class: string,
  doors: string,
  heading: string,
  jobs: any[],
}

export const DISPATCH_MENU = writable<DISPATCHMENU_DATA[]>(null);
export const DISPATCH_MENUS = writable<DISPATCHMENU_DATA>(null);


interface LOCALE_DATA {
  dispatch_detach: string,
  dispatch_attach: string,
  unit: string,
  units: string,
  additionals: string,
}

export const Locale = writable<LOCALE_DATA>(null);

export const processedDispatchMenu = derived(
  [DISPATCH_MENU, MAX_CALL_LIST, PLAYER],
  ([$DISPATCH_MENU, $MAX_CALL_LIST, $PLAYER]) => {
    if (!$DISPATCH_MENU || $MAX_CALL_LIST === null || !$PLAYER) {
      // Handling null or undefined values
      return [];
    }

    return $DISPATCH_MENU
      .slice(-$MAX_CALL_LIST)
      .filter(dispatch =>
        dispatch.message && dispatch.jobs.includes($PLAYER.job.type)
      )
      .reverse();
  }
);