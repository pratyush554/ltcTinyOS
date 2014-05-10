configuration ProjectSecondAppC
{
}

implementation {
  components ProjectSecondC, MainC, LedsC, ActiveMessageC;
  components CollectionC as Collector;
  components new CollectionSenderC(AM_EASYCOLLECTION);
  components new TimerMilliC();
  components new DemoSensorC() as Sensor;
  

  ProjectSecondC.Boot -> MainC;
  ProjectSecondC.RoutingControl -> Collector;
  ProjectSecondC.Leds -> LedsC;
  ProjectSecondC.Timer -> TimerMilliC;
  ProjectSecondC.Send -> CollectionSenderC;
  ProjectSecondC.RootControl -> Collector;
  ProjectSecondC.Receive -> Collector.Receive[AM_EASYCOLLECTION];
  ProjectSecondC.RadioControl -> ActiveMessageC;
  ProjectSecondC.TempRead->Sensor;
}

