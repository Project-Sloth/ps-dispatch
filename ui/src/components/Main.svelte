<script>
  import { onMount, afterUpdate } from 'svelte';
  import { DISPATCH, removeDispatch, RESPOND_KEYBIND, IS_RIGHT_MARGIN, shortCalls } from '@store/stores';
  import { fly } from 'svelte/transition';
  import { timeAgo } from '@utils/timeAgo';

  let notifications = [];
  
  DISPATCH.subscribe(value => {
    notifications = value || [];
  });

  function removeNotification(id) {
    removeDispatch(id);
  }

  onMount(() => {
    notifications.forEach(notification => {
      const { data, timer } = notification;
      setTimeout(() => {
        removeNotification(data.id);
      }, timer);
    });
  });

  afterUpdate(() => {
    notifications.forEach(notification => {
      const { data, timer } = notification;
      setTimeout(() => {
        removeNotification(data.id);
      }, timer);
    });
  });

  function getDispatchData(dispatch) {
    if ($shortCalls) {
      return [
        { label: 'Call', value: dispatch.data.message },
        { icon: 'fas fa-comment', label: 'Information', value: dispatch.data.information },
      ];
    } else {
      return [
      { icon: 'fas fa-clock', label: 'Time', value: timeAgo(dispatch.data.time) },
      { icon: 'fas fa-user', label: 'Name', value: dispatch.data.name },
      { icon: 'fas fa-phone', label: 'Number', value: dispatch.data.number },
      { icon: 'fas fa-comment', label: 'Information', value: dispatch.data.information },
      { icon: 'fas fa-map-location-dot', label: 'Street', value: dispatch.data.street },
      { icon: 'fas fa-user', label: 'Gender', value: dispatch.data.gender },
      { icon: 'fas fa-gun', label: 'Automatic Gun Fire', value: dispatch.data.automaticGunFire },
      { icon: 'fas fa-gun', label: 'Weapon', value: dispatch.data.weapon },
      { icon: 'fas fa-car', label: 'Vehicle', value: dispatch.data.vehicle },
      { icon: 'fas fa-rectangle-list', label: 'Plate', value: dispatch.data.plate },
      { icon: 'fas fa-droplet', label: 'Color', value: dispatch.data.color },
      { icon: 'fas fa-car', label: 'Class', value: dispatch.data.class },
      { icon: 'fas fa-door-open', label: 'Doors', value: dispatch.data.doors },
      { icon: 'fas fa-compass', label: 'Heading', value: dispatch.data.heading },
      ];
    }
  }
</script>


<div class="w-screen h-screen flex justify-end { $IS_RIGHT_MARGIN ? 'flex-row' : 'flex-row-reverse' } items-end">
  <div class="w-[25%] h-[97%]"
       class:ml-[2vh]={!$IS_RIGHT_MARGIN}
       class:mr-[2vh]={$IS_RIGHT_MARGIN}
      >
    {#each notifications.slice().reverse() as dispatch, index (dispatch.data.id)}
      <div class="w-full h-fit my-[0.5vh] font-medium {dispatch.data.priority == 1 ? " bg-priority_secondary" : " bg-secondary"}" transition:fly="{{ x: $IS_RIGHT_MARGIN ? 400 : -400 }}">
        <div class="flex items-center gap-[1vh] p-[1vh] text-[1.5vh] {dispatch.data.priority == 1 ? " bg-priority_primary" : " bg-primary"}">
          <p class="px-[2vh] py-[0.2vh] rounded-full bg-accent_green">
            #{dispatch.data.id}
          </p>
          <p class="px-[2vh] py-[0.2vh] rounded-full {dispatch.data.priority == 1 ? " bg-accent_red" : "bg-accent_cyan"}">
            {dispatch.data.code}
          </p>
          <p class="py-[0.2vh]">
            {dispatch.data.message}
          </p>
          <i class="{dispatch.data.icon} py-[0.2vh] ml-auto mr-[0.5vh] {dispatch.data.priority == 1 ? " text-accent_red" : "text-accent_cyan"}"></i>
        </div>
        <div class="flex">
          <div class="flex flex-col p-[1vh] gap-y-[0.4vh] text-[1.4vh] w-[70%]">
              {#if dispatch.data}
                {#each getDispatchData(dispatch) as field}
                  {#if field.value}
                    <p>
                      <i class={field.icon + ' mr-[0.5vh]'}></i>
                      {field.label}: {field.value}
                    </p>
                  {/if}
                {/each}
              {/if}
          </div>
          <div class="w-[30%] flex items-end justify-center mb-[1vh]">
            {#if index === 0}
              <p class="px-[1.5vh] py-[0.4vh] rounded-full text-[1.3vh] {dispatch.data.priority == 1 ? " bg-priority_primary" : " bg-primary"}">
                [{$RESPOND_KEYBIND}] Respond
              </p>
            {/if}
          </div>
        </div>
      </div>
    {/each}
  </div>
</div>
