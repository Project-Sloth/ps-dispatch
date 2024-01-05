<script>
  import { PLAYER, Locale, DISPATCH_MENU, DISPATCH_MUTED, DISPATCH_DISABLED, IS_RIGHT_MARGIN, processedDispatchMenu } from '@store/stores';
  import { fly, slide } from 'svelte/transition';
	import { timeAgo } from '@utils/timeAgo'
	import { SendNUI } from '@utils/SendNUI'
	import { onDestroy, onMount } from 'svelte'
  
  let activeCallId = null;
  let additionalUnitsVisible = {};
  let unsubscribe;

  $: menuRight = false;

  onMount(() => {
    unsubscribe = IS_RIGHT_MARGIN.subscribe((value) => {
      menuRight = value;
    })
  })

  onDestroy(() => {
    unsubscribe();
  })
  
  function toggleDispatch(id) {
    if (activeCallId === id) {
      activeCallId = null;
    } else {
      activeCallId = id;
    }
  }

  function CheckIfAttached(units, player) {
    for (let i = 0; i < units.length; i++) {
      if (units[i].citizenid === player) {
        return true;
      }
    }
    return false;
  }

  function toggleAdditionalUnits(callId) {
    additionalUnitsVisible[callId] = !additionalUnitsVisible[callId];
  }

  function getAdditionalUnitsCount(dispatch) {
    const maxVisibleUnits = 3;
    const additionalUnits = dispatch.units.length - maxVisibleUnits;
    return Math.max(0, additionalUnits);
  }

  function toggleMargin() {
    menuRight = !menuRight;

    IS_RIGHT_MARGIN.set(menuRight);
  }

  function toggleMute() {
    DISPATCH_MUTED.update(value => !value);
    SendNUI("toggleMute", { boolean: $DISPATCH_MUTED });
  }

  function toggleAlerts() {
    DISPATCH_DISABLED.update(value => !value);
    SendNUI("toggleAlerts", { boolean: $DISPATCH_DISABLED });
  }

  function getDispatchData(dispatch) {
    return [
      { icon: 'fas fa-clock', label: 'Time', value: timeAgo(dispatch.time) },
      { icon: 'fas fa-user', label: 'Name', value: dispatch.name },
      { icon: 'fas fa-phone', label: 'Number', value: dispatch.number },
      { icon: 'fas fa-comment', label: 'Information', value: dispatch.information },
      { icon: 'fas fa-map-location-dot', label: 'Street', value: dispatch.street },
      { icon: 'fas fa-user', label: 'Gender', value: dispatch.gender },
      { icon: 'fas fa-gun', label: 'Automatic Gun Fire', value: dispatch.automaticGunFire },
      { icon: 'fas fa-gun', label: 'Weapon', value: dispatch.weapon },
      { icon: 'fas fa-car', label: 'Vehicle', value: dispatch.vehicle },
      { icon: 'fas fa-rectangle-list', label: 'Plate', value: dispatch.plate },
      { icon: 'fas fa-droplet', label: 'Color', value: dispatch.color },
      { icon: 'fas fa-car', label: 'Class', value: dispatch.class },
      { icon: 'fas fa-door-open', label: 'Doors', value: dispatch.doors },
      { icon: 'fas fa-compass', label: 'Heading', value: dispatch.heading },
      { icon: 'fas fa-user-group', label: 'Units', value: dispatch.units.length },
    ];
  }
</script>

<div class="w-screen h-screen flex items-center justify-end { menuRight ? 'flex-row' : 'flex-row-reverse' } " transition:fly="{{ x: menuRight ? 400 : -400 }}">
  <!-- CONTROLS -->
  <div class="w-[3.2vh] h-[85%] flex flex-col gap-[1vh]" class:ml-[1vh]={!menuRight} class:mr-[1vh]={menuRight}>

    <!-- REFRESH ALERTS -->
    <button class="w-full h-[3vh] flex items-center justify-center bg-primary hover:bg-secondary"

      on:click={() => {
        SendNUI("refreshAlerts");
      }}
    >
      <i class="fas fa-arrows-rotate text-[1.5vh]"></i>
    </button>
    <!-- TOGGLE MUTE -->
    <button class="w-full h-[3vh] flex items-center justify-center bg-primary hover:bg-secondary"
      on:click={toggleMute}
    >
      <i class="fas fa-volume-{$DISPATCH_MUTED ? "xmark" : "high"} text-[1.5vh]"></i>
    </button>
    <!-- TOGGLE ALERTS -->
    <button class="w-full h-[3vh] flex items-center justify-center bg-primary hover:bg-secondary"
      on:click={toggleAlerts}
    >
      <i class="fas fa-{$DISPATCH_DISABLED ? "bell-slash" : "bell"} text-[1.5vh]"></i>
    </button>
    <!-- CLEAR BLIPS -->
    <button class="w-full h-[3vh] flex items-center justify-center bg-primary hover:bg-secondary"
      on:click={() => {
        SendNUI("clearBlips");
      }}
    >
    <i class="fas fa-ban text-[1.5vh]"></i>

    </button>
    <!-- Toggle Margin -->
    <button class="w-full h-[3vh] flex items-center justify-center bg-primary hover:bg-secondary"
      on:click={toggleMargin}
    >
    <i class="fas fa-{menuRight ? "hand-point-left" : "hand-point-right"} text-[1.5vh]"></i>

    </button>
  </div>
  <!-- MENU -->
  <div class="w-[25%] h-[97%] overflow-auto pr-[0.5vh]" class:ml-[2vh]={!menuRight} class:mr-[2vh]={menuRight}>
    {#if $DISPATCH_MENU}
    {#each $processedDispatchMenu as dispatch}
    <button class="w-full h-fit mb-[1vh] font-medium {dispatch.priority == 1 ? 'bg-priority_secondary' : 'bg-secondary'}" on:click={() => toggleDispatch(dispatch.id)}>
        <div class="flex items-center gap-[1vh] p-[1vh] text-[1.5vh] {dispatch.priority == 1 ? " bg-priority_primary" : " bg-primary"}">
            <p class="px-[2vh] py-[0.2vh] rounded-full bg-accent_green">
              #{dispatch.id}
            </p>
            <p class="px-[2vh] py-[0.2vh] rounded-full {dispatch.priority == 1 ? " bg-accent_red" : "bg-accent_cyan"}">
              {dispatch.code}
            </p>
            <p class="py-[0.2vh]">
              {dispatch.message}
            </p>
            <i class="{dispatch.icon} py-[0.2vh] ml-auto mr-[0.5vh] {dispatch.priority == 1 ? " text-accent_red" : "text-accent_cyan"}"></i>
          </div>
          <div class="flex flex-col p-[1vh] gap-y-[0.4vh] text-[1.4vh] w-full text-start">
              {#each getDispatchData(dispatch) as field}
                {#if field.value}
                  <p>
                    <i class={field.icon + ' mr-[0.5vh]'}></i>
                    {field.label}: {field.value}
                  </p>
                {/if}
              {/each}
          </div>
        </button>
        <!-- UNITS, ATTACH AND DETACH -->
        {#if activeCallId === dispatch.id}
        <div class=" mb-[1vh]" transition:slide={{ duration: 300 }}>
          {#if dispatch.units.length > 0}
            <div class="flex flex-col gap-[0.2vh] mb-[1vh] bg-primary">
              {#each dispatch.units.slice(0, additionalUnitsVisible[dispatch.id] ? dispatch.units.length : 3) as unit}
                <div class="w-full h-[5vh] flex {dispatch.priority == 1 ? 'bg-priority_tertiary' : 'bg-tertiary'} flex items-center font-medium">
                  <p class="ml-[2vh] px-[1.4vh] py-[0.2vh] rounded-full {dispatch.priority == 1 ? 'bg-priority_secondary' : 'bg-secondary'}">{unit.metadata.callsign}</p>
                  <p class="mx-[1vh] px-[1.5vh] py-[0.2vh] rounded-full uppercase {unit.job.type == "leo" ? "bg-[#004ca5] " : unit.job.type == "ems" ? "bg-[#e03535]" : "bg-[#4b4b4b]" }">{unit.job.name}</p>
                  <p class="ml-[0.5vh]">{unit.charinfo.firstname} {unit.charinfo.lastname}</p>
                </div>
              {/each}
              {#if dispatch.units.length > 3}
                {#if !additionalUnitsVisible[dispatch.id]}
                  <button class="w-full h-[5vh] flex items-center justify-center {dispatch.priority == 1 ? 'bg-priority_tertiary' : 'bg-tertiary'} flex items-center font-medium" on:click={() => toggleAdditionalUnits(dispatch.id)}>
                    <p class="ml-[0.5vh]">+{getAdditionalUnitsCount(dispatch)} {$Locale.additionals}</p>
                  </button>
                {/if}
              {/if}
            </div>
          {/if}
          <button class="w-full h-[5vh] {dispatch.priority == 1 ? " bg-priority_quaternary" : " bg-accent_green"} flex items-center font-medium"
            on:click={() => {
              if (CheckIfAttached(dispatch.units, $PLAYER.citizenid)) {
                SendNUI("detachUnit", dispatch );
                SendNUI("refreshAlerts");
              } else {
                SendNUI("attachUnit", dispatch );
                SendNUI("refreshAlerts");
              }
            }}>
            <p class="mx-[2vh] px-[2vh] py-[0.2vh] rounded-full {dispatch.priority == 1 ? " bg-accent_dark_red" : "  bg-accent_dark_green"} ">{dispatch.units.length} {$Locale.units}</p>
            <p class="ml-[3vh]">
              {#if CheckIfAttached(dispatch.units, $PLAYER.citizenid)}
                {$Locale.dispatch_detach}
              {:else}
                {$Locale.dispatch_attach}
              {/if}
            </p>
          </button>
        </div>
        {/if}
      {/each}
    {/if}
  </div>
</div>

