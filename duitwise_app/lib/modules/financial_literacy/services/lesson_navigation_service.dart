// lib/modules/financial_literacy/services/lesson_navigation_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/lesson_model.dart';

class LessonNavigationService {
  // Show lesson detail modal with learning outcomes
  static void showLessonDetail(BuildContext context, Lesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lesson Title
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
                        
              // Description
              Text(
                lesson.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Learning Outcomes Section
              if (lesson.learningOutcomes.isNotEmpty) ...[
                const Text(
                  'What You Will Learn:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Learning Outcomes List
                Column(
                  children: lesson.learningOutcomes.map((outcome) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              outcome,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 20),
              ],
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  // Close Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Start Lesson Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close modal
                        _openYouTubeWithLoading(context, lesson);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Lesson',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Open YouTube with 5-second loading screen
  static void _openYouTubeWithLoading(BuildContext context, Lesson lesson) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _YouTubeLoadingDialog(lesson: lesson),
    );
  }
}

// Loading Dialog Widget
class _YouTubeLoadingDialog extends StatefulWidget {
  final Lesson lesson;
  
  const _YouTubeLoadingDialog({required this.lesson});
  
  @override
  State<_YouTubeLoadingDialog> createState() => _YouTubeLoadingDialogState();
}

class _YouTubeLoadingDialogState extends State<_YouTubeLoadingDialog> {
  int _countdown = 5;
  bool _isOpening = false;
  String _status = 'Preparing to open YouTube...';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        _status = 'Opening YouTube in $_countdown seconds...';
      });

      if (_countdown <= 0) {
        timer.cancel();
        _openYouTubeNow();
      }
    });
  }

  Future<void> _openYouTubeNow() async {
    if (_isOpening) return;
    
    setState(() {
      _isOpening = true;
      _status = 'Opening YouTube...';
    });

    final videoUrl = widget.lesson.videoUrl;
    
    if (videoUrl == null || videoUrl.isEmpty) {
      _showError('No video URL provided');
      return;
    }

    try {
      // Extract video ID
      final videoId = _extractVideoId(videoUrl);
      
      if (videoId.isEmpty) {
        throw Exception('Invalid YouTube URL');
      }
      
      // Try to open in YouTube app first
      final youtubeAppUri = Uri.parse('vnd.youtube:$videoId');
      final youtubeWebUri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
      
      bool launched = false;
      
      // Try YouTube app
      if (await canLaunchUrl(youtubeAppUri)) {
        launched = await launchUrl(
          youtubeAppUri,
          mode: LaunchMode.externalApplication,
        );
      }
      
      // If YouTube app fails, try browser
      if (!launched) {
        launched = await launchUrl(
          youtubeWebUri,
          mode: LaunchMode.externalApplication,
        );
      }
      
      if (launched) {
        // Success - close dialog and return to app
        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      } else {
        throw Exception('Cannot open YouTube');
      }
      
    } catch (e) {
      _showError('Failed to open: $e');
    }
  }

  String _extractVideoId(String url) {
    try {
      // Method 1: v= parameter
      final vMatch = RegExp(r'[?&]v=([^&#]+)').firstMatch(url);
      if (vMatch != null && vMatch.group(1) != null) {
        return vMatch.group(1)!;
      }
      
      // Method 2: youtu.be/ format
      final shortMatch = RegExp(r'youtu\.be/([^&#?]+)').firstMatch(url);
      if (shortMatch != null && shortMatch.group(1) != null) {
        return shortMatch.group(1)!;
      }
      
      // Method 3: embed/ format
      final embedMatch = RegExp(r'youtube\.com/embed/([^&#?]+)').firstMatch(url);
      if (embedMatch != null && embedMatch.group(1) != null) {
        return embedMatch.group(1)!;
      }
      
      return '';
    } catch (e) {
      return '';
    }
  }

  void _showError(String error) {
    setState(() {
      _status = 'Error: $error';
      _isOpening = false;
    });
    
    // Show retry option after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Failed to Open YouTube'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openYouTubeNow();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isOpening
                  ? const Icon(
                      Icons.open_in_new,
                      size: 60,
                      color: Colors.blue,
                      key: ValueKey('opening'),
                    )
                  : CircularProgressIndicator(
                      value: (5 - _countdown) / 5,
                      strokeWidth: 6,
                      color: Colors.red,
                      backgroundColor: Colors.grey.shade300,
                      key: const ValueKey('progress'),
                    ),
            ),
            
            const SizedBox(height: 20),
            
            // Countdown display
            Text(
              _countdown > 0 ? '$_countdown' : 'Opening...',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Status text
            Text(
              _status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Lesson info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: Colors.red.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lesson.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.lesson.category, // REMOVED duration
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Cancel button (only during countdown)
            if (_countdown > 0 && !_isOpening)
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}