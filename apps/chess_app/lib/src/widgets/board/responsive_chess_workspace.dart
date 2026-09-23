import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Centralized, high-performance responsive chess workspace layout ensuring the
/// chessboard dynamically dominates available screen real estate without unused space.
/// Provides dynamic sizing controls: [−] [Size Slider] [+] [AUTO] [MAX] and collapsible side panel.
class ResponsiveChessWorkspace extends StatefulWidget {
  final Widget Function(BuildContext context, double boardSize) boardBuilder;
  final Widget? header;
  final Widget? footer;
  final Widget? sidePanel;
  final String sidePanelTitle;
  final Widget? evalBar;
  final double evalBarWidth;
  final double initialScale;
  final bool initialSidePanelCollapsed;
  final ValueChanged<double>? onScaleChanged;
  final ValueChanged<bool>? onSidePanelToggled;
  final List<Widget> customTopActions;

  const ResponsiveChessWorkspace({
    super.key,
    required this.boardBuilder,
    this.header,
    this.footer,
    this.sidePanel,
    this.sidePanelTitle = 'Game Notation & Diagnostics',
    this.evalBar,
    this.evalBarWidth = 32.0,
    this.initialScale = 1.0,
    this.initialSidePanelCollapsed = false,
    this.onScaleChanged,
    this.onSidePanelToggled,
    this.customTopActions = const [],
  });

  @override
  State<ResponsiveChessWorkspace> createState() => _ResponsiveChessWorkspaceState();
}

class _ResponsiveChessWorkspaceState extends State<ResponsiveChessWorkspace> {
  late double _scaleMultiplier;
  late bool _isSidePanelCollapsed;
  bool _isAutoMode = true;

  @override
  void initState() {
    super.initState();
    _scaleMultiplier = widget.initialScale.clamp(0.70, 1.45);
    _isSidePanelCollapsed = widget.initialSidePanelCollapsed;
  }

  void _setScale(double scale, {bool isAuto = false}) {
    setState(() {
      _scaleMultiplier = scale.clamp(0.70, 1.45);
      _isAutoMode = isAuto;
    });
    widget.onScaleChanged?.call(_scaleMultiplier);
  }

  void _toggleSidePanel() {
    setState(() {
      _isSidePanelCollapsed = !_isSidePanelCollapsed;
    });
    widget.onSidePanelToggled?.call(_isSidePanelCollapsed);
  }

  void _toggleMaxMode() {
    setState(() {
      if (_isSidePanelCollapsed && _scaleMultiplier >= 1.30) {
        // Exit MAX mode: restore default auto and side panel
        _isSidePanelCollapsed = false;
        _scaleMultiplier = 1.0;
        _isAutoMode = true;
      } else {
        // Enter MAX mode: collapse side panel and maximize board
        _isSidePanelCollapsed = true;
        _scaleMultiplier = 1.45;
        _isAutoMode = false;
      }
    });
    widget.onScaleChanged?.call(_scaleMultiplier);
    widget.onSidePanelToggled?.call(_isSidePanelCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        final isMobile = screenWidth < 768;
        final isTablet = screenWidth >= 768 && screenWidth < 1080;
        final isDesktop = screenWidth >= 1080;
        final isLandscape = screenWidth > screenHeight && screenHeight < 600;

        // Sizing control bar widget
        final sizingControlsBar = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.surfLight.withAlpha(160),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.brd.withAlpha(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Zoom out [-]
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                tooltip: 'Decrease Board Size',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                onPressed: () => _setScale(_scaleMultiplier - 0.05),
              ),

              // Zoom slider (hidden on narrow mobile to conserve space)
              if (!isMobile)
                SizedBox(
                  width: 100,
                  height: 24,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      activeTrackColor: ChessTheme.primaryLight,
                      thumbColor: ChessTheme.primaryLight,
                    ),
                    child: Slider(
                      value: _scaleMultiplier,
                      min: 0.70,
                      max: 1.45,
                      onChanged: (val) => _setScale(val),
                    ),
                  ),
                ),

              // Zoom in [+]
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                tooltip: 'Increase Board Size',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                onPressed: () => _setScale(_scaleMultiplier + 0.05),
              ),

              const SizedBox(width: 6),

              // AUTO button
              InkWell(
                onTap: () => _setScale(1.0, isAuto: true),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isAutoMode ? ChessTheme.primary.withAlpha(40) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _isAutoMode ? ChessTheme.primaryLight : context.brd),
                  ),
                  child: Text(
                    'AUTO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _isAutoMode ? ChessTheme.primaryLight : context.txtSec,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // MAX button
              InkWell(
                onTap: _toggleMaxMode,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: (_isSidePanelCollapsed && _scaleMultiplier >= 1.30)
                        ? ChessTheme.accentGold.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: (_isSidePanelCollapsed && _scaleMultiplier >= 1.30)
                          ? ChessTheme.accentGold
                          : context.brd,
                    ),
                  ),
                  child: Text(
                    'MAX',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: (_isSidePanelCollapsed && _scaleMultiplier >= 1.30)
                          ? ChessTheme.accentGold
                          : context.txtSec,
                    ),
                  ),
                ),
              ),

              // Side panel toggle on desktop & tablet
              if (widget.sidePanel != null && !isMobile) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isSidePanelCollapsed ? Icons.view_sidebar_outlined : Icons.view_sidebar,
                    size: 16,
                    color: _isSidePanelCollapsed ? context.txtSec : ChessTheme.primaryLight,
                  ),
                  tooltip: _isSidePanelCollapsed ? 'Show Side Panel' : 'Collapse Side Panel',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  onPressed: _toggleSidePanel,
                ),
              ],
            ],
          ),
        );

        if (isMobile && !isLandscape) {
          return _buildMobilePortraitLayout(
            context,
            constraints,
            sizingControlsBar,
          );
        } else if (isLandscape) {
          return _buildLandscapeLayout(
            context,
            constraints,
            sizingControlsBar,
          );
        } else {
          return _buildDesktopTabletLayout(
            context,
            constraints,
            sizingControlsBar,
            isTablet: isTablet,
            isDesktop: isDesktop,
          );
        }
      },
    );
  }

  Widget _buildDesktopTabletLayout(
    BuildContext context,
    BoxConstraints constraints,
    Widget sizingControlsBar, {
    required bool isTablet,
    required bool isDesktop,
  }) {
    final hasEvalBar = widget.evalBar != null;
    final evalSpace = hasEvalBar ? widget.evalBarWidth + 12.0 : 0.0;

    // Calculate side panel width
    final sidePanelWidth = _isSidePanelCollapsed || widget.sidePanel == null
        ? 0.0
        : (isTablet ? 300.0 : (constraints.maxWidth * 0.33).clamp(320.0, 480.0));

    final availableBoardWidth = math.max(
      240.0,
      constraints.maxWidth - sidePanelWidth - evalSpace - 48.0,
    );

    // Approximate header and footer heights
    const controlsBarHeight = 36.0;
    const verticalGutters = 32.0;
    final headerHeight = widget.header != null ? 54.0 : 0.0;
    final footerHeight = widget.footer != null ? 92.0 : 0.0;
    final availableBoardHeight = math.max(
      200.0,
      constraints.maxHeight - controlsBarHeight - verticalGutters - headerHeight - footerHeight,
    );

    final maxPossibleSquare = math.min(availableBoardWidth, availableBoardHeight);
    final targetBoardSize = _isAutoMode
        ? maxPossibleSquare * 0.98
        : (maxPossibleSquare * 0.96 * _scaleMultiplier).clamp(240.0, maxPossibleSquare);

    final boardSize = math.min(targetBoardSize, maxPossibleSquare);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Dominant Board Section
          Expanded(
            child: Column(
              children: [
                // Top control bar with sizing slider & custom actions
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.customTopActions,
                      ),
                      sizingControlsBar,
                    ],
                  ),
                ),

                // Optional Workspace Header (e.g. Opponent clock, pedagogical banner)
                if (widget.header != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: widget.header!,
                  ),

                // Board + Eval Bar Row
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasEvalBar) ...[
                          SizedBox(
                            width: widget.evalBarWidth,
                            height: boardSize,
                            child: widget.evalBar!,
                          ),
                          const SizedBox(width: 12),
                        ],
                        SizedBox(
                          width: boardSize,
                          height: boardSize,
                          child: widget.boardBuilder(context, boardSize),
                        ),
                      ],
                    ),
                  ),
                ),

                // Optional Workspace Footer (e.g. Player clock, in-game controls)
                if (widget.footer != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: widget.footer!,
                  ),
              ],
            ),
          ),

          // Right: Side Panel (if present and not collapsed)
          if (widget.sidePanel != null && !_isSidePanelCollapsed) ...[
            const SizedBox(width: 16),
            SizedBox(
              width: sidePanelWidth,
              child: Card(
                elevation: 0,
                color: context.surf,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: context.brd),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.sidePanel!,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobilePortraitLayout(
    BuildContext context,
    BoxConstraints constraints,
    Widget sizingControlsBar,
  ) {
    final hasEvalBar = widget.evalBar != null;
    final evalSpace = hasEvalBar ? widget.evalBarWidth + 8.0 : 0.0;

    final availableWidth = math.max(200.0, constraints.maxWidth - evalSpace - 16.0);
    final availableHeight = constraints.maxHeight * 0.52;

    final maxSquare = math.min(availableWidth, availableHeight);
    final boardSize = _isAutoMode
        ? maxSquare * 0.98
        : (maxSquare * _scaleMultiplier).clamp(200.0, maxSquare);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sizing toolbar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.customTopActions,
              ),
              sizingControlsBar,
            ],
          ),
          const SizedBox(height: 8),

          // Header
          if (widget.header != null) widget.header!,
          const SizedBox(height: 6),

          // Board & Eval Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasEvalBar) ...[
                SizedBox(
                  width: widget.evalBarWidth,
                  height: boardSize,
                  child: widget.evalBar!,
                ),
                const SizedBox(width: 8),
              ],
              SizedBox(
                width: boardSize,
                height: boardSize,
                child: widget.boardBuilder(context, boardSize),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Footer
          if (widget.footer != null) widget.footer!,
          const SizedBox(height: 8),

          // Side panel content displayed below board
          if (widget.sidePanel != null)
            Card(
              elevation: 0,
              color: context.surf,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.brd),
              ),
              child: SizedBox(
                height: 280,
                child: widget.sidePanel!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    BoxConstraints constraints,
    Widget sizingControlsBar,
  ) {
    final hasEvalBar = widget.evalBar != null;
    final evalSpace = hasEvalBar ? widget.evalBarWidth + 8.0 : 0.0;

    final boardHeight = math.max(200.0, constraints.maxHeight - 20.0);
    final boardSize = math.min(boardHeight, constraints.maxWidth * 0.55 - evalSpace);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Board
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasEvalBar) ...[
                SizedBox(
                  width: widget.evalBarWidth,
                  height: boardSize,
                  child: widget.evalBar!,
                ),
                const SizedBox(width: 8),
              ],
              SizedBox(
                width: boardSize,
                height: boardSize,
                child: widget.boardBuilder(context, boardSize),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Controls & Panel
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sizingControlsBar,
                  if (widget.header != null) widget.header!,
                  if (widget.footer != null) widget.footer!,
                  if (widget.sidePanel != null)
                    SizedBox(
                      height: 220,
                      child: widget.sidePanel!,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
