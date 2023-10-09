<script lang="ts">
	import VisibilityProvider from '@providers/VisibilityProvider.svelte'
	import { BROWSER_MODE, RESOURCE_NAME, VISIBILITY, Locale  } from '@store/stores'
	import DebugBrowser from '@providers/DebugBrowser.svelte'
	import AlwaysListener from '@providers/AlwaysListener.svelte'
	import Menu from '@components/Menu.svelte'
	import Main from '@components/Main.svelte'

	$RESOURCE_NAME  = 'ps-dispatch'
</script>


{#if $Locale}
	<VisibilityProvider>
		<Menu />
	</VisibilityProvider>

	<Main />
{/if}

<AlwaysListener />

{#if $BROWSER_MODE}
	<DebugBrowser />
	<body class="bg-neutral-700"></body>
{/if}
