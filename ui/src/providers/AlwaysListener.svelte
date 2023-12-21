<script lang="ts">
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { debugData } from '@utils/debugData'
	import { VISIBILITY, BROWSER_MODE, DISPATCH_MENU, DISPATCH_MENUS, DISPATCH, PLAYER, Locale, RESPOND_KEYBIND, MAX_CALL_LIST, shortCalls } from '@store/stores';

	debugData([
		{
			action: 'setVisible',
			data: true,
		},
	])

	debugData([
		{
			action: 'setBrowserMode',
			data: true
		},
	])

	function browserHideAndShow(e: KeyboardEvent) {
		if (e.key === '=') {
			$VISIBILITY = true
		}
	}

	ReceiveNUI('setBrowserMode', (data: boolean) => {
		BROWSER_MODE.set(data)
		console.log('browser mode enabled')
		if (data) {
			window.addEventListener('keydown', browserHideAndShow)
		} else {
			window.removeEventListener('keydown', browserHideAndShow)
		}
	})

	ReceiveNUI('newCall', (data: any) => {
		DISPATCH.update(dispatches => {
			dispatches = dispatches || [];
			dispatches.push(data);
			return dispatches;
		});
	});

	ReceiveNUI('setDispatchs', (data: any) => {
		DISPATCH_MENU.set(data)
	});

	ReceiveNUI('setupUI', (data: any) => {
		PLAYER.set(data.player)
		Locale.set(data.locales)
		RESPOND_KEYBIND.set(data.keybind)
		MAX_CALL_LIST.set(data.maxCallList)
		shortCalls.set(data.shortCalls)
	});

</script>
