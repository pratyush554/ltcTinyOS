COMPONENT=ProjectSecondAppC

CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp
CFLAGS += -DTOSH_DATA_LENGTH=90

include $(MAKERULES)
