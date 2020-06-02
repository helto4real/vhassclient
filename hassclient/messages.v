module hassclient

import json

pub struct HassMessage {
	pub:
	id				int						= -1
	message_type 	string [json:'type']
	// event			string [raw]
	// result			string [raw]
}


// Parse the message type from Home Assistant message
fn parse_hass_message(jsn string) ?HassMessage {
	msg:= json.decode(HassMessage, jsn) or {return error(err)}
	return msg
}

// fn parse_hass_message_ptr(jsn_ptr voidptr) ?HassMessage {
// 	msg := parse_hass_message(jsn_ptr.str()) or  {return error(err)}
// 	return msg
// }