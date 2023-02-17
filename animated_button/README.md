
## Features

This package is mainly used to show the button as an animated with the customized color & behaviour.
User can add his own color & behaviour ,shape .

## Example

AnimatedButton(
  width: 280,
  height: 46,
  borderRadius: 30,
  borderColor: Colors.blue,
  color: StyleTheme().softBlue,
  child: Text(
  'Animated Button',
  style: StyleTheme().textStyleWhite(16, FontWeight.w600),
  ),
  controller: _btnController,
  onPressed: () {
  Submit(context);
},
), 

