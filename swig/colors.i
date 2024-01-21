%rename(at) TAttrPair::operator[];
%rename(asInt) TColorRGB::operator uint32_t;
%rename(asInt) TColorBIOS::operator uint8_t;
%rename(asInt) TColorXTerm::operator uint8_t;
%rename(asInt) TColorAttr::operator uchar;
%rename(asInt) TAttrPair::operator ushort;

%include "tvision/colors.h"
