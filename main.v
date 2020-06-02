module main

import hassclient as hc

struct MyStruct {
	some_text string
	enabled   bool = false
	width     int = 0
	height    int = 0
}


fn main() {
	c := hc.new_connection(
		hc.ConnectionConfig {
			hass_uri: "ws://192.168.1.7:8123/api/websocket",
			token: 'asdasd'
		}
	)
	//hass_uri: "ws://192.168.1.7:8123/api/websocket",
	c.connect()


}
