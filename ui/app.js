$(document).ready(() => {
	window.addEventListener('message', function (event) {
		let data = event.data;
		if (data.update == 'newCall') {
			addNewCall(data.callID, data.timer, data.data, data.isPolice);
		}
	});
});

const MONTH_NAMES = [
	'January',
	'February',
	'March',
	'April',
	'May',
	'June',
	'July',
	'August',
	'September',
	'October',
	'November',
	'December',
];

function getFormattedDate(date, prefomattedDate = false, hideYear = false) {
	const day = date.getDate();
	const month = MONTH_NAMES[date.getMonth()];
	const year = date.getFullYear();
	const hours = date.getHours();
	let minutes = date.getMinutes();

	if (minutes < 10) {
		minutes = `0${minutes}`;
	}

	if (prefomattedDate) {
		return `${prefomattedDate} at ${hours}:${minutes}`;
	}

	if (hideYear) {
		return `${day}. ${month} at ${hours}:${minutes}`;
	}

	return `${day}. ${month} ${year}. at ${hours}:${minutes}`;
}

function timeAgo(dateParam) {
	if (!dateParam) {
		return null;
	}

	const date =
		typeof dateParam === 'object' ? dateParam : new Date(dateParam);
	const DAY_IN_MS = 86400000;
	const today = new Date();
	const yesterday = new Date(today - DAY_IN_MS);
	const seconds = Math.round((today - date) / 1000);
	const minutes = Math.round(seconds / 60);
	const isToday = today.toDateString() === date.toDateString();
	const isYesterday = yesterday.toDateString() === date.toDateString();
	const isThisYear = today.getFullYear() === date.getFullYear();

	if (seconds < 5) {
		return 'Just Now';
	} else if (seconds < 60) {
		return `${seconds} Seconds ago`;
	} else if (seconds < 90) {
		return 'About a minute ago';
	} else if (minutes < 60) {
		return `${minutes} Minutes ago`;
	} else if (isToday) {
		return getFormattedDate(date, 'Today');
	} else if (isYesterday) {
		return getFormattedDate(date, 'Yesterday');
	} else if (isThisYear) {
		return getFormattedDate(date, false, true);
	}

	return getFormattedDate(date);
}

function addNewCall(callID, timer, info, isPolice) {
	const prio = info['priority'];
	let DispatchItem;
	if (info['isDead']) {
		DispatchItem = `<div class="dispatch-item ${callID} dispatch-item-${info['isDead']} animate__animated"><div class="top-info-holder"><div class="call-id">#${callID}</div><div class="call-code priority-${prio}">${info.dispatchCode}</div><div class="call-name">${info.dispatchMessage}</div></div><div class="bottom-info-holder">`;
	} else {
		DispatchItem = `<div class="dispatch-item ${callID} dispatch-item-${isPolice} animate__animated"><div class="top-info-holder"><div class="call-id">#${callID}</div><div class="call-code priority-${prio}">${info.dispatchCode}</div><div class="call-name">${info.dispatchMessage}</div></div><div class="bottom-info-holder">`;
	}

	// Above we are defining a default dispatch item and then we will append the data we have been sent.

	if (info['time']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-clock"></span>${timeAgo(
			info['time']
		)}</div>`;
	}

	if (info['firstStreet']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-map-pin"></span>${info['firstStreet']}</div>`;
	}

	if (info['heading']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-share"></span>${info['heading']}</div>`;
	}

	if (info['callsign']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-solid fa-eye"></span>${info['callsign']}</div>`;
	}

	if (info['doorCount']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-door-open"></span>${info['doorCount']}</div>`;
	}

	if (info['weapon']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-bullseye"></span>${info['weapon']}</div>`;
	}

	if (info['camId']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-camera"></span>${info['camId']}</div>`;
	}

	if (info['gender']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-genderless"></span>${info['gender']}</div>`;
	}

	if (info['model'] && info['plate']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-car"></span>${info['model']}<span class="fas fa-digital-tachograph" style="margin-left: 2vh;"></span>${info['plate']}</div>`;
	} else if (info['plate']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-digital-tachograph"></span>${info['plate']}</div>`;
	} else if (info['model']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-car"></span>${info['model']}</div>`;
	}

	if (info['firstColor']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-spray-can"></span>${info['firstColor']}</div>`;
	}
	if (info['automaticGunfire'] == true) {
		DispatchItem += `<div class="call-bottom-info"><span class="fab fa-blackberry"></span>Automatic Gunfire</div>`;
	}

	if (info['name'] && info['number']) {
		DispatchItem += `<div class="call-bottom-info"><span class="far fa-id-badge"></span>${info['name']}<span class="fas fa-mobile-alt" style="margin-left: 2vh;"></span>${info['number']}</div>`;
	} else if (info['number']) {
		DispatchItem += `<div class="call-bottom-info"><span class="fas fa-mobile-alt"></span>${info['number']}</div>`;
	} else if (info['name']) {
		DispatchItem += `<div class="call-bottom-info"><span class="far fa-id-badge"></span>${info['name']}</div>`;
	}

	if (info['information']) {
		DispatchItem += `<div class="line"></div><div class="call-bottom-info call-bottom-information"><span class="far fa-question-circle"></span>${info['information']}</div>`;
	}

	DispatchItem += `</div></div>`;

	$('.dispatch-holder').prepend(DispatchItem);

	var timer = 4000;

	if (prio == 1) {
		timer = 12000;
	} else if (prio == 2) {
		timer = 9000;
	}

	$(`.${callID}`).addClass('animate__backInRight');
	setTimeout(() => {
		$(`.${callID}`).addClass('animate__backOutRight');
		setTimeout(() => {
			$(`.${callID}`).remove();
		}, 1000);
	}, timer || 4500);
}
