#undef Uses_TEvent

%ignore TTimerQueue;
%include "tvision/system.h"

struct MouseEventType
{
  TPoint where;
  ushort eventFlags;          // Replacement for doubleClick.
  ushort controlKeyState;
  uchar buttons;
  uchar wheel;

private:
  MouseEventType();
};

struct CharScanType
{
  uchar charCode;
  uchar scanCode;
};

%rename(asTKey) KeyDownEvent::operator TKey();

struct KeyDownEvent
{
  ushort keyCode;
  CharScanType charScan;
  ushort controlKeyState;
  char text[4];               // NOT null-terminated.
  uchar textLength;

  TStringView getText() const;
  operator TKey() const;

private:
  KeyDownEvent();
};

struct MessageEvent
{
  ushort command;
  void *infoPtr;
  int32_t infoLong;
  ushort infoWord;
  short infoInt;
  uchar infoByte;
  char infoChar;

private:
  MessageEvent();
};

struct TEvent
{
  ushort what;
  MouseEventType mouse;
  KeyDownEvent keyDown;
  MessageEvent message;
};

#define Uses_TEvent
