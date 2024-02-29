return {
    StartLocation = {
        coords = vec3(501.67, 5603.7, 797.91), -- Mt Chiliad map.
        label = 'Start The Hunt',
        icon = 'fa fa-search',
        item = 'compass',
        itemAdd = 'clueone',
    },  
    Locations = {
        [1] = {
            coords = vec4(2817.81, 1463.46, 24.86, 0.0),
            label = 'Look Inside',
            icon = 'fa fa-search',
            item = 'weapon_crowbar',
            bar = {
                label = "Looting The Box",
                duration = 5000,
            },
            itemAdd = 'cluetwo',
        },
        [2] = {
            coords = vec4(2908.49, 4342.91, 50.3, 0.0),
            label = 'Loot This Box',
            icon = 'fa fa-search',
            item = 'weapon_crowbar',
            bar = {
                label = "Looting The Box",
                duration = 5000,
            },
            itemAdd = 'cluethree',
        },
        [3] = {
            coords = vec4(2132.71, 1948.35, 93.8, 0.0),
            label = 'Search',
            icon = 'fa fa-search',
            item = 'weapon_crowbar',
            bar = {
                label = "Searching",
                duration = 5000,
            },
            itemAdd = 'cluefour',
        },
        [4] = {
            coords = vec4(-98.97, 938.81, 233.03, 0.0),
            label = 'Loot',
            icon = 'fa fa-search',
            item = 'weapon_crowbar',
            bar = {
                label = "Looting",
                duration = 5000,
            },
            itemAdd = 'cluefive',
        },
        [5] = {
            coords = vec4(-1181.73, -752.67, 19.55, 0.0),
            label = 'Loot Box',
            icon = 'fa fa-search',
            item = 'weapon_crowbar',
            bar = {
                label = "Looting The Box",
                duration = 5000,
            },
            itemAdd = 'weapon_pistol',
        },
    },
    PropModel = `xm3_prop_xm3_boxwood_01a`,
}