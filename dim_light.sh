#!/bin/sh
deviceid=$1
dim=$2
duration=$3

WEMO_SRV=http://192.168.0.79:49153
WEMO_ENDPOINT=$WEMO_SRV/upnp/control/bridge1
SOAP_ACTION_HEADER="SOAPAction: \"urn:Belkin:service:bridge:1#SetDeviceStatus\""
CONTENT_TYPE_HEADER="Content-Type: text/xml; charset=\"utf-8\""

data="<?xml version=\"1.0\"?>
<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
<s:Body>
<u:SetDeviceStatus xmlns:u=\"urn:Belkin:service:bridge:1\">
  <DeviceStatusList>
    <DeviceStatus>
      <IsGroupAction>NO</IsGroupAction>
      <DeviceID available=\"YES\">$deviceid</DeviceID>
      <CapabilityID>10008</CapabilityID>
      <CapabilityValue>$dim:$duration</CapabilityValue>
    </DeviceStatus>
  </DeviceStatusList>
</u:SetDeviceStatus>
</s:Body>
</s:Envelope>"

data="<?xml version=\"1.0\"?>
<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
<s:Body>
<u:SetDeviceStatus xmlns:u=\"urn:Belkin:service:bridge:1\">
<DeviceStatusList>&lt;xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;&gt;
&lt;DeviceStatus&gt;
&lt;IsGroupAction&gt;NO&lt;/IsGroupAction&gt;
&lt;DeviceID available=&quot;YES&quot;&gt;$deviceid&lt;/DeviceID&gt;
&lt;CapabilityID&gt;10008&lt;/CapabilityID&gt;
&lt;CapabilityValue&gt;$dim:$duration&lt;/CapabilityValue&gt;
&lt;/DeviceStatus&gt;</DeviceStatusList>
</u:SetDeviceStatus>
</s:Body>
</s:Envelope>"

curl -H "$SOAP_ACTION_HEADER" \
     -H "$CONTENT_TYPE_HEADER" \
     --data "$data" \
     $WEMO_ENDPOINT
