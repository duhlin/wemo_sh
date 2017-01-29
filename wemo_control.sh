#!/bin/sh

command=$(basename $0)

CURL_OPTIONS=-s
WEMO_SRV=http://192.168.0.79:49153
CONTENT_TYPE_HEADER="Content-Type: text/xml; charset=\"utf-8\""

SetDeviceStatus () {
  WEMO_ENDPOINT=$WEMO_SRV/upnp/control/bridge1
  SOAP_ACTION_HEADER="SOAPAction: \"urn:Belkin:service:bridge:1#SetDeviceStatus\""
  deviceid=$1
  capabilityId=$2
  capabilityValue=$3
  data="<?xml version=\"1.0\"?>
    <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
    <s:Body>
    <u:SetDeviceStatus xmlns:u=\"urn:Belkin:service:bridge:1\">
    <DeviceStatusList>&lt;xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;&gt;
    &lt;DeviceStatus&gt;
    &lt;IsGroupAction&gt;NO&lt;/IsGroupAction&gt;
    &lt;DeviceID available=&quot;YES&quot;&gt;$deviceid&lt;/DeviceID&gt;
    &lt;CapabilityID&gt;$capabilityId&lt;/CapabilityID&gt;
    &lt;CapabilityValue&gt;$capabilityValue&lt;/CapabilityValue&gt;
    &lt;/DeviceStatus&gt;</DeviceStatusList>
    </u:SetDeviceStatus>
    </s:Body>
    </s:Envelope>"

  curl $CURL_OPTIONS \
    -H "$SOAP_ACTION_HEADER" \
    -H "$CONTENT_TYPE_HEADER" \
    --data "$data" \
    $WEMO_ENDPOINT
}

GetMacAddr () {
  WEMO_ENDPOINT=$WEMO_SRV/upnp/control/basicevent1
  SOAP_ACTION_HEADER="SOAPAction: \"urn:Belkin:service:basicevent:1#GetMacAddr\""
  data="<?xml version=\"1.0\" encoding=\"utf-8\"?>
    <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
    <s:Body>
    <u:GetMacAddr xmlns:u=\"urn:Belkin:service:basicevent:1\">
    </u:GetMacAddr>
    </s:Body>
    </s:Envelope>"
  
  curl $CURL_OPTIONS \
    -H "$SOAP_ACTION_HEADER" \
    -H "$CONTENT_TYPE_HEADER" \
    --data "$data" \
    $WEMO_ENDPOINT
}

GetEndDevices () {
  WEMO_ENDPOINT=$WEMO_SRV/upnp/control/bridge1
  SOAP_ACTION_HEADER="SOAPAction: \"urn:Belkin:service:bridge:1#GetEndDevices\""
  devUDN=$1
  data="<?xml version=\"1.0\" encoding=\"utf-8\"?>
    <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
    <s:Body>
    <u:GetEndDevices xmlns:u=\"urn:Belkin:service:bridge:1\">
    <ReqListType>PAIRED_LIST</ReqListType>
    <DevUDN>$devUDN</DevUDN>
    </u:GetEndDevices>
    </s:Body>
    </s:Envelope>"

  curl $CURL_OPTIONS \
    -H "$SOAP_ACTION_HEADER" \
    -H "$CONTENT_TYPE_HEADER" \
    --data "$data" \
    $WEMO_ENDPOINT
}

case $command in
  wemo_light_dim)
    deviceid=$1
    dim=$2
    duration=$3
    SetDeviceStatus $deviceid 10008 $dim:$duration
    ;;
  wemo_light_toggle)
    deviceid=$1
    devicestatus=$2
    SetDeviceStatus $deviceid 10006 $devicestatus
    ;;
  wemo_list)
    GetMacAddr
    devUDN=uuid:Bridge-1_0-231614B01002E0
    GetEndDevices $devUDN
    ;;    
  *)
    echo "unsupported command: $command"
    ;;
esac


