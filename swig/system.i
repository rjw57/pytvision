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

struct KeyDownEvent
{
  ushort keyCode;
  CharScanType charScan;
  ushort controlKeyState;


private:
  KeyDownEvent();
};

%extend KeyDownEvent {
  TKey asTKey() { return TKey(*$self); }

  %typemap(out) const KeyDownEvent* {
    $result = PyUnicode_FromStringAndSize($1->text, $1->textLength);
  }

  const KeyDownEvent* getText() { return $self; }
}

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
