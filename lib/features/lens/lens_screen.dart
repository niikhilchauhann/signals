import 'dart:convert';
import 'dart:io';
import '/core/export.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensState {
  final File? image;
  final bool loading;
  final int loadingStep;
  final Map<String, dynamic>? parsedResult;
  final String? rawFallback;

  _LensState({
    this.image,
    this.loading = false,
    this.loadingStep = 0,
    this.parsedResult,
    this.rawFallback,
  });

  _LensState copyWith({
    File? image,
    bool? loading,
    int? loadingStep,
    Map<String, dynamic>? parsedResult,
    String? rawFallback,
    bool clearParsedResult = false,
    bool clearRawFallback = false,
  }) {
    return _LensState(
      image: image ?? this.image,
      loading: loading ?? this.loading,
      loadingStep: loadingStep ?? this.loadingStep,
      parsedResult: clearParsedResult ? null : (parsedResult ?? this.parsedResult),
      rawFallback: clearRawFallback ? null : (rawFallback ?? this.rawFallback),
    );
  }
}

class _LensScreenState extends State<LensScreen> {
  final ValueNotifier<_LensState> _state = ValueNotifier(_LensState());

  static const String geminiApiKey = String.fromEnvironment('GEMINI_API');

  static const _loadingSteps = [
    'Uploading image...',
    'Analyzing chart patterns...',
    'Generating insights...',
  ];

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (picked == null) return;

      _state.value = _state.value.copyWith(
        image: File(picked.path),
        clearParsedResult: true,
        clearRawFallback: true,
      );
    } catch (e) {
      _showError("Image picker failed");
    }
  }

  Future<void> _analyzeChart() async {
    final currentState = _state.value;
    if (currentState.image == null) return;

    _state.value = currentState.copyWith(
      loading: true,
      loadingStep: 0,
      clearParsedResult: true,
      clearRawFallback: true,
    );

    try {
      final bytes = await currentState.image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      _state.value = _state.value.copyWith(loadingStep: 1);

      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$geminiApiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      'Analyze this trading chart. Return ONLY valid JSON with no markdown formatting:\n'
                      '{"trend":"Bullish/Bearish/Sideways",'
                      '"signal":"Buy/Sell/Wait",'
                      '"confidence":75,'
                      '"summary":"One concise line about the setup",'
                      '"risks":["risk1","risk2"],'
                      '"action":"Specific actionable recommendation"}'
                },
                {
                  "inlineData": {
                    "mimeType": "image/png",
                    "data": base64Image,
                  },
                },
              ],
            },
          ],
        }),
      );

      _state.value = _state.value.copyWith(loadingStep: 2);

      final data = jsonDecode(response.body);
      final text =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? '';

      // Try to parse JSON from the response
      try {
        // Remove any markdown code block wrapping
        String cleaned = text.trim();
        if (cleaned.startsWith('```')) {
          cleaned = cleaned.replaceAll(RegExp(r'^```\w*\n?'), '');
          cleaned = cleaned.replaceAll(RegExp(r'\n?```$'), '');
          cleaned = cleaned.trim();
        }
        final parsed = jsonDecode(cleaned) as Map<String, dynamic>;
        _state.value = _state.value.copyWith(
          parsedResult: parsed,
          loading: false,
        );
      } catch (_) {
        // Fallback: show raw text if JSON parsing fails
        _state.value = _state.value.copyWith(
          rawFallback: text.replaceAll("**", ""),
          loading: false,
        );
      }
    } catch (e) {
      _state.value = _state.value.copyWith(loading: false);
      _showError("Analysis failed. Please try again.");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_LensState>(
      valueListenable: _state,
      builder: (context, state, child) {
        return Scaffold(
          body: Container(
            decoration: AppDecorations.screenBackground,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Header
                    Text('Chart Lens', style: AppTextTheme.size24Bold),
                    const SizedBox(height: 4),
                    Text(
                      'Upload a chart for instant AI analysis',
                      style: AppTextTheme.size14Normal.copyWith(
                        color: AppColors.grey,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sectionGap),

                    // Upload card
                    _UploadCard(
                      image: state.image,
                      onPickImage: _pickImage,
                    ),

                    const SizedBox(height: AppSpacing.itemGap),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: 'Upload',
                            icon: Icons.image_rounded,
                            onTap: _pickImage,
                            isPrimary: false,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.itemGap),
                        Expanded(
                          child: _ActionButton(
                            label: 'Analyze',
                            icon: Icons.auto_graph_rounded,
                            onTap: state.image != null && !state.loading
                                ? _analyzeChart
                                : null,
                            isPrimary: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sectionGap),

                    // Loading state
                    if (state.loading) _LoadingProgress(step: state.loadingStep),

                    // Parsed result cards
                    if (state.parsedResult != null) _AnalysisResult(data: state.parsedResult!),

                    // Fallback raw text
                    if (state.rawFallback != null) _RawResult(text: state.rawFallback!),

                    // Disclaimer
                    if (state.parsedResult != null || state.rawFallback != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sectionGap),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        border: Border.all(
                          color: AppColors.red.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16,
                              color: AppColors.red.withValues(alpha: 0.6)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Educational purpose only. Not financial advice.',
                              style: AppTextTheme.size12Normal.copyWith(
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
      },
    );
  }
}

// ─────────────────────────────────────────
// Upload Card
// ─────────────────────────────────────────

class _UploadCard extends StatelessWidget {
  final File? image;
  final VoidCallback onPickImage;

  const _UploadCard({required this.image, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: double.infinity,
        height: image != null ? null : 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.cardLarge),
          border: Border.all(
            color: image != null
                ? AppColors.cardBorder
                : AppColors.primaryPurple.withValues(alpha: 0.3),
            width: image != null ? 1 : 1.5,
          ),
          boxShadow: AppShadows.card,
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.cardLarge - 1),
                child: Image.file(
                  image!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primaryPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to upload a chart',
                    style: AppTextTheme.size16Bold.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG — max 5MB',
                    style: AppTextTheme.size12Normal.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Action Button
// ─────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary
              ? (isEnabled ? AppColors.primaryPurple : AppColors.grey)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: isPrimary
              ? null
              : Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : AppColors.darkGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextTheme.size14Bold.copyWith(
                color: isPrimary ? Colors.white : AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Loading Progress
// ─────────────────────────────────────────

class _LoadingProgress extends StatelessWidget {
  final int step;

  const _LoadingProgress({required this.step});

  static const _steps = [
    'Uploading image...',
    'Analyzing chart patterns...',
    'Generating insights...',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.card(),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final isActive = i == step;
          final isDone = i < step;

          return Padding(
            padding: EdgeInsets.only(bottom: i < _steps.length - 1 ? 12 : 0),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.green.withValues(alpha: 0.12)
                        : isActive
                            ? AppColors.primaryPurple.withValues(alpha: 0.12)
                            : AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          size: 16, color: AppColors.green)
                      : isActive
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryPurple,
                              ),
                            ).px(7)
                          : Icon(Icons.circle,
                              size: 8, color: AppColors.grey),
                ),
                const SizedBox(width: 12),
                Text(
                  _steps[i],
                  style: AppTextTheme.size14Normal.copyWith(
                    color: isActive
                        ? AppColors.primaryPurple
                        : isDone
                            ? AppColors.green
                            : AppColors.grey,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Parsed Analysis Result
// ─────────────────────────────────────────

class _AnalysisResult extends StatelessWidget {
  final Map<String, dynamic> data;

  const _AnalysisResult({required this.data});

  Color _trendColor(String? trend) {
    switch (trend?.toLowerCase()) {
      case 'bullish':
        return AppColors.green;
      case 'bearish':
        return AppColors.redLight;
      default:
        return AppColors.secondaryViolet;
    }
  }

  IconData _signalIcon(String? signal) {
    switch (signal?.toLowerCase()) {
      case 'buy':
        return Icons.trending_up_rounded;
      case 'sell':
        return Icons.trending_down_rounded;
      default:
        return Icons.pause_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trend = data['trend'] as String? ?? 'Unknown';
    final signal = data['signal'] as String? ?? 'Wait';
    final confidence = (data['confidence'] as num?)?.toInt() ?? 50;
    final summary = data['summary'] as String? ?? '';
    final risks = (data['risks'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final action = data['action'] as String? ?? '';

    final trendColor = _trendColor(trend);
    final progress = confidence.clamp(0, 100) / 100.0;

    return Column(
      children: [
        // Signal & Trend card
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: AppDecorations.card(),
          child: Row(
            children: [
              // Confidence circle
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 5,
                        backgroundColor: AppColors.chipBackground,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(trendColor),
                      ),
                    ),
                    Text(
                      '$confidence%',
                      style: AppTextTheme.size14Bold.copyWith(
                        color: trendColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: AppDecorations.chip(color: trendColor),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 8, color: trendColor),
                              const SizedBox(width: 4),
                              Text(
                                trend,
                                style: AppTextTheme.size12Bold.copyWith(
                                  color: trendColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: AppDecorations.chip(color: trendColor),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_signalIcon(signal),
                                  size: 14, color: trendColor),
                              const SizedBox(width: 4),
                              Text(
                                signal,
                                style: AppTextTheme.size12Bold.copyWith(
                                  color: trendColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence',
                      style: AppTextTheme.size12Normal.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.itemGap),

        // Summary card
        if (summary.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: AppDecorations.card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.summarize_rounded,
                        size: 16, color: AppColors.primaryPurple),
                    const SizedBox(width: 8),
                    Text('Summary', style: AppTextTheme.size14Bold),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  style: AppTextTheme.size14Normal.copyWith(
                    color: AppColors.darkGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.itemGap),

        // Action card
        if (action.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: AppDecorations.card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.play_circle_outline_rounded,
                        size: 16, color: AppColors.green),
                    const SizedBox(width: 8),
                    Text('Recommended Action',
                        style: AppTextTheme.size14Bold),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  action,
                  style: AppTextTheme.size14Normal.copyWith(
                    color: AppColors.darkGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

        // Risks card (collapsible)
        if (risks.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.itemGap),
          _CollapsibleCard(
            title: 'Risks',
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.yellow,
            children: risks
                .map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle, size: 6,
                              color: AppColors.yellow),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              r,
                              style: AppTextTheme.size14Normal.copyWith(
                                color: AppColors.darkGrey,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────
// Collapsible Card
// ─────────────────────────────────────────

class _CollapsibleCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _CollapsibleCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  State<_CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<_CollapsibleCard> {
  final ValueNotifier<bool> _expanded = ValueNotifier(false);

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _expanded,
      builder: (context, expanded, child) {
        return Container(
          decoration: AppDecorations.card(),
          child: Column(
            children: [
              InkWell(
                onTap: () => _expanded.value = !expanded,
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Row(
                    children: [
                      Icon(widget.icon, size: 16, color: widget.iconColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.title, style: AppTextTheme.size14Bold),
                      ),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (expanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.cardPadding,
                    0,
                    AppSpacing.cardPadding,
                    AppSpacing.cardPadding,
                  ),
                  child: Column(children: widget.children),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Raw Fallback Result
// ─────────────────────────────────────────

class _RawResult extends StatelessWidget {
  final String text;

  const _RawResult({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16,
                  color: AppColors.primaryPurple),
              const SizedBox(width: 8),
              Text('AI Analysis', style: AppTextTheme.size16Bold),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: AppTextTheme.size14Normal.copyWith(
              height: 1.5,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
