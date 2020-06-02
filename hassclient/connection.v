module hassclient
import net.websocket
import time

pub struct HassConnection {
	hass_uri	string
	pub:
	token		string
	mut:
	ws 			&websocket.Client
	sequence 	int = 1
}

pub struct ConnectionConfig {
	hass_uri 	string
	token		string
}

pub fn new_connection(c ConnectionConfig) &HassConnection {

	println(c)
	mut d := &HassConnection {
		hass_uri: c.hass_uri,
		token: c.token,
		ws: websocket.new(c.hass_uri)
	}
	d.ws.nonce_size = 16 // For python back-ends
	d.ws.subscriber.subscribe_method('on_open', on_open, d)
	d.ws.subscriber.subscribe_method('on_message', on_message, d)
	d.ws.subscriber.subscribe_method('on_error', on_error, d)
	d.ws.subscriber.subscribe_method('on_close', on_close, d)

	return d
}

// Connects to Home Assistant
pub fn (mut d HassConnection) connect () {
	mut ws := d.ws
	println("Connecting...")
	status := ws.connect()
	println("connect status: ${status}")
	go ws.listen()

	for true {
		time.sleep_ms(5000)
	}
}

fn on_open(mut d HassConnection, ws websocket.Client, _ voidptr) {
	println('websocket opened.')

}

// Try to see if this fixes anything from @spytheman
fn check(){ m := HassMessage{} println(m) }

fn on_message(mut d HassConnection, ws websocket.Client, msg &websocket.Message) {
	match msg.opcode {
		.binary_frame {
			println("Got binary frame")
			println(msg)
			println(string(byteptr(msg.payload)))
		}
		.text_frame {
			println("Got text frame")
			println(msg.payload.str())
			// println(tos2(msg.payload))
			hass_msg := parse_hass_message(msg.payload.str()) or
				{
					println(err)
					HassMessage {}
				}

			// Reversing order of the following make it compile
			println(hass_msg.id)
			println(hass_msg)
		}
		else {
			println("unhandled opcode")
		}
	}
}

fn on_close(mut d HassConnection, ws websocket.Client, _ voidptr) {
	println('websocket closed.')
}

fn on_error(mut d HassConnection, ws websocket.Client, err string) {
	println('we have an error.')
	println(err)
}