import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/lesson_model.dart';
import '../services/quiz_navigation_service.dart';

class VideoPlayerPage extends StatefulWidget {
  final Lesson lesson;
  
  const VideoPlayerPage({super.key, required this.lesson});
  
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isLoading = false;
  bool _showCompletionScreen = false;
  
  @override
  void initState() {
    super.initState();
    
    // Auto-open YouTube when page loads
    _openYouTubeVideo();
  }
  
  Future<void> _openYouTubeVideo() async {
    final videoUrl = widget.lesson.videoUrl;
    
    if (videoUrl == null || videoUrl.isEmpty) {
      _showErrorDialog('No video URL provided');
      return;
    }
    
    setState(() => _isLoading = true);
    
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
      
      // If browser fails, show error
      if (!launched) {
        throw Exception('Cannot open YouTube');
      }
      
      setState(() => _isLoading = false);
      
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Failed to open video: $e');
    }
  }

  String _extractVideoId(String url) {
    
    try {
      // Method 1: v= parameter
      final vMatch = RegExp(r'[?&]v=([^&#]+)').firstMatch(url);
      if (vMatch != null && vMatch.group(1) != null) {
        final id = vMatch.group(1)!;
        return id;
      }
      
      // Method 2: youtu.be/ format
      final shortMatch = RegExp(r'youtu\.be/([^&#?]+)').firstMatch(url);
      if (shortMatch != null && shortMatch.group(1) != null) {
        final id = shortMatch.group(1)!;
        return id;
      }
      
      // Method 3: embed/ format
      final embedMatch = RegExp(r'youtube\.com/embed/([^&#?]+)').firstMatch(url);
      if (embedMatch != null && embedMatch.group(1) != null) {
        final id = embedMatch.group(1)!;
        return id;
      }
      
      return '';
    } catch (e) {
      return '';
    }
  }
  
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Error'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 10),
              const Text('The video will open in YouTube app or browser.'),
              const SizedBox(height: 10),
              if (widget.lesson.videoUrl != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Original URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SelectableText(widget.lesson.videoUrl!),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openYouTubeVideo(); // Retry
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  void _showCompletionOptions() {
    
    setState(() {
      _showCompletionScreen = true;
    });
  }
  
  void _returnToLearning() {
    Navigator.of(context).pop();
  }

  void _takeQuiz() {
    Navigator.of(context).pop();
    QuizNavigationService.showQuizDialog(context, widget.lesson);
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: const Color(0xFFA0E5C7),
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _showCompletionOptions,
            tooltip: 'Mark as Complete',
          ),
        ],
      ),
      body: _showCompletionScreen 
          ? _buildCompletionScreen()
          : _buildVideoPlayer(),
    );
  }
  
  Widget _buildVideoPlayer() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Opening YouTube...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.lesson.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              // Video is playing in YouTube app/browser
              Icon(
                Icons.play_circle_filled,
                size: 80,
                color: Colors.red[700],
              ),
              const SizedBox(height: 20),
              const Text(
                'Video is playing in YouTube',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Return to this screen after watching',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                widget.lesson.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _openYouTubeVideo,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open YouTube Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
            
            const SizedBox(height: 40),
            
            // "I'm Done" Button
            ElevatedButton.icon(
              onPressed: _showCompletionOptions,
              icon: const Icon(Icons.check_circle),
              label: const Text('I\'m Done Watching'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            
            const SizedBox(height: 20),
            
            TextButton(
              onPressed: _returnToLearning,
              child: const Text(
                'Return to Lessons',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCompletionScreen() {
    return Container(
      color: const Color(0xFFA0E5C7),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Celebration Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration,
                  size: 60,
                  color: Colors.amber,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Lesson Completed!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                'Great job completing "${widget.lesson.title}"',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Test your knowledge with a quiz',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Quiz Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.quiz,
                              color: Colors.blue.shade700,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lesson Quiz',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Test what you\'ve learned',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.lesson.durationMinutes} sec',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Action Buttons
              Row(
                children: [
                  // Return to Learning Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _returnToLearning,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text(
                        'Return to Lessons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Take Quiz Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _takeQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Take Quiz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Optional: Skip Quiz
              TextButton(
                onPressed: _returnToLearning,
                child: const Text(
                  'Skip quiz for now',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}