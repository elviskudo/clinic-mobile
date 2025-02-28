import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AnimatedAIResponse extends StatefulWidget {
  final String response;
  final double fontSize;
  final double lineHeight;
  final bool animate; // Add this parameter to control animation

  const AnimatedAIResponse({
    Key? key,
    required this.response,
    this.fontSize = 14,
    this.lineHeight = 1.5,
    this.animate = true, // Default to true for backward compatibility
  }) : super(key: key);

  @override
  State<AnimatedAIResponse> createState() => _AnimatedAIResponseState();
}

class _AnimatedAIResponseState extends State<AnimatedAIResponse> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _startTypingAnimation();
    } else {
      // If animation is disabled, display full text immediately
      setState(() {
        _displayedText = widget.response;
        _animationComplete = true;
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedAIResponse oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the content actually changed (not just truncated/expanded)
    bool contentChanged = oldWidget.response != widget.response && 
                         !widget.response.startsWith(oldWidget.response) && 
                         !oldWidget.response.startsWith(widget.response);
    
    if (contentChanged && widget.animate) {
      _resetAnimation();
    } else if (oldWidget.response != widget.response) {
      // Just update the display text without animation
      setState(() {
        _displayedText = widget.response;
        _animationComplete = true;
      });
    }
  }

  void _resetAnimation() {
    _timer?.cancel();
    setState(() {
      _displayedText = '';
      _currentIndex = 0;
      _animationComplete = false;
    });
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (_currentIndex < widget.response.length) {
        setState(() {
          _displayedText = widget.response.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _animationComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMarkdownText(_displayedText),
        if (!_animationComplete && widget.animate)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.fast_forward),
                  label: const Text('Skip'),
                  onPressed: () {
                    _timer?.cancel();
                    setState(() {
                      _displayedText = widget.response;
                      _animationComplete = true;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMarkdownText(String text) {
    // Ensure text is valid for markdown rendering
    String safeText = text.isNotEmpty ? text : ' ';

    return MarkdownBody(
      data: safeText,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: widget.fontSize,
          height: widget.lineHeight,
          color: Colors.black,
        ),
        h1: TextStyle(
          fontSize: widget.fontSize + 8,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        h2: TextStyle(
          fontSize: widget.fontSize + 6,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        h3: TextStyle(
          fontSize: widget.fontSize + 4,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        h4: TextStyle(
          fontSize: widget.fontSize + 2,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        h5: TextStyle(
          fontSize: widget.fontSize + 1,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        h6: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        em: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.black87,
        ),
        strong: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        code: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey.shade200,
          color: Colors.black87,
        ),
        blockquote: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey.shade700,
        ),
        blockSpacing: 8,
        listIndent: 24,
        listBullet: TextStyle(
          color: Colors.black87,
        ),
      ),
      softLineBreak: true,
    );
  }
}