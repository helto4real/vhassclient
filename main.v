module main

import hassclient as hc
import net.websocket
import log

fn main() {
	c := hc.new_connection(
		hc.ConnectionConfig {
			hass_uri: "ws://192.168.1.7:8123/api/websocket",
			token: '' // Uses the HASS_TOKEN env instead if empty
			log_level: log.Level.debug
		}
	)
	println('CONNECTING!')
	c.subscribe_change_events(on_state_changed)
	c.connect()

}

fn on_state_changed(c &hc.HassConnection, ws websocket.Client, state &hc.HassEventData) {
	println('$state.entity_id : $state.new_state.state ($state.old_state.state), $state.new_state.last_updated; $state.new_state.last_updated.microsecond')
}
