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
  final VoidCallback? onFullscreenToggled;
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
    this.initialScale = 0.88,
    this.initialSidePanelCollapsed = false,
    this.onScaleChanged,
    this.onSidePanelToggled,
    this.onFullscreenToggled,
    this.customTopActions = const [],
  });

  @override
  State<ResponsiveChessWorkspace> createState() => _ResponsiveChessWorkspaceState();
}

enum WorkspaceSizeMode { auto, fit, max, custom }

class _ResponsiveChessWorkspaceState extends State<ResponsiveChessWorkspace> {
  /// Fraction of board scale from 0.0 (minimum size) to 1.0 (true available maximum)
  late double _scaleFraction;
  late bool _isSidePanelCollapsed;
  WorkspaceSizeMode _sizeMode = WorkspaceSizeMode.auto;
  bool _isFullscreen = false;
  double? _draggedSidePanelWidth;

  @override
  void initState() {
    super.initState();
    // Normalize initialScale (handles either 0.0-1.0 or legacy 0.70-1.45)
    if (widget.initialScale > 1.0) {
      _scaleFraction = ((widget.initialScale - 0.70) / (1.45 - 0.70)).clamp(0.0, 1.0);
    } else {
      _scaleFraction = widget.initialScale.clamp(0.0, 1.0);
    }
    _isSidePanelCollapsed = widget.initialSidePanelCollapsed;
    if (_scaleFraction >= 0.999) {
      _sizeMode = WorkspaceSizeMode.fit;
    } else if ((_scaleFraction - 0.88).abs() < 0.01) {
      _sizeMode = WorkspaceSizeMode.auto;
    } else {
      _sizeMode = WorkspaceSizeMode.custom;
    }
  }

  void _setScaleFraction(double val, {WorkspaceSizeMode mode = WorkspaceSizeMode.custom}) {
    setState(() {
      _scaleFraction = val.clamp(0.0, 1.0);
      _sizeMode = mode;
    });
    widget.onScaleChanged?.call(_scaleFraction);
  }

  void _increaseScale() {
    if (_scaleFraction < 0.999) {
      final next = math.min(1.0, (_scaleFraction + 0.06));
      _setScaleFraction(next, mode: next >= 0.999 ? WorkspaceSizeMode.fit : WorkspaceSizeMode.custom);
    }
  }

  void _decreaseScale() {
    if (_scaleFraction > 0.001) {
      final prev = math.max(0.0, (_scaleFraction - 0.06));
      _setScaleFraction(prev, mode: prev <= 0.001 ? WorkspaceSizeMode.custom : WorkspaceSizeMode.custom);
    }
  }

  void _toggleSidePanel() {
    setState(() {
      _isSidePanelCollapsed = !_isSidePanelCollapsed;
    });
    widget.onSidePanelToggled?.call(_isSidePanelCollapsed);
  }

  void _setAutoMode() {
    _setScaleFraction(0.88, mode: WorkspaceSizeMode.auto);
  }

  void _setFitMode() {
    _setScaleFraction(1.0, mode: WorkspaceSizeMode.fit);
  }

  void _toggleMaxMode() {
    setState(() {
      if (_sizeMode == WorkspaceSizeMode.max && _isSidePanelCollapsed) {
        // Exit MAX: restore auto mode and restore side panel
        _isSidePanelCollapsed = false;
        _scaleFraction = 0.88;
        _sizeMode = WorkspaceSizeMode.auto;
      } else {
        // Enter MAX: collapse side panel and maximize board size to 100%
        _isSidePanelCollapsed = true;
        _scaleFraction = 1.0;
        _sizeMode = WorkspaceSizeMode.max;
      }
    });
    widget.onScaleChanged?.call(_scaleFraction);
    widget.onSidePanelToggled?.call(_isSidePanelCollapsed);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    widget.onFullscreenToggled?.call();
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

        final canZoomIn = _scaleFraction < 0.999;
        final canZoomOut = _scaleFraction > 0.001;

        // Sizing control bar widget with [−] [Slider] [+] [AUTO] [FIT] [MAX] [FULLSCREEN]
        final sizingControlsBar = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.surfLight.withAlpha(160),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.brd.withAlpha(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Zoom out [-] with visible disable state
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                tooltip: canZoomOut ? 'Decrease Board Size' : 'Minimum Board Size Reached',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                onPressed: canZoomOut ? _decreaseScale : null,
              ),

              // Zoom slider (desktop & tablet)
              if (!isMobile)
                SizedBox(
                  width: constraints.maxWidth < 900 ? 55 : 90,
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
                      value: _scaleFraction,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (val) => _setScaleFraction(val),
                    ),
                  ),
                ),

              // Zoom in [+] with visible disable state (NO SILENT NO-OPS)
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                tooltip: canZoomIn ? 'Increase Board Size' : 'Maximum size',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                onPressed: canZoomIn ? _increaseScale : null,
              ),

              const SizedBox(width: 4),

              // AUTO button
              InkWell(
                onTap: _setAutoMode,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _sizeMode == WorkspaceSizeMode.auto ? ChessTheme.primary.withAlpha(40) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _sizeMode == WorkspaceSizeMode.auto ? ChessTheme.primaryLight : context.brd),
                  ),
                  child: Text(
                    'AUTO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _sizeMode == WorkspaceSizeMode.auto ? ChessTheme.primaryLight : context.txtSec,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // FIT button (Fits 100% available space with side panel)
              InkWell(
                onTap: _setFitMode,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _sizeMode == WorkspaceSizeMode.fit ? ChessTheme.secondary.withAlpha(40) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _sizeMode == WorkspaceSizeMode.fit ? ChessTheme.secondary : context.brd),
                  ),
                  child: Text(
                    'FIT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _sizeMode == WorkspaceSizeMode.fit ? ChessTheme.secondary : context.txtSec,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // MAX button (Collapses side panel and maximizes board)
              InkWell(
                onTap: _toggleMaxMode,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _sizeMode == WorkspaceSizeMode.max
                        ? ChessTheme.accentGold.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _sizeMode == WorkspaceSizeMode.max
                          ? ChessTheme.accentGold
                          : context.brd,
                    ),
                  ),
                  child: Text(
                    'MAX',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _sizeMode == WorkspaceSizeMode.max
                          ? ChessTheme.accentGold
                          : context.txtSec,
                    ),
                  ),
                ),
              ),

              // FULLSCREEN button
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  size: 16,
                  color: _isFullscreen ? ChessTheme.accentGold : context.txtSec,
                ),
                tooltip: _isFullscreen ? 'Exit Fullscreen' : 'Fullscreen Workspace',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                onPressed: _toggleFullscreen,
              ),

              // Side panel toggle on desktop & tablet
              if (widget.sidePanel != null && !isMobile) ...[
                const SizedBox(width: 4),
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

    // Calculate side panel width (with drag-resizable override support)
    final baseSidePanelWidth = _draggedSidePanelWidth ??
        (isTablet ? (constraints.maxWidth * 0.30).clamp(200.0, 260.0) : (constraints.maxWidth * 0.28).clamp(280.0, 420.0));
    final sidePanelWidth = (_isSidePanelCollapsed || widget.sidePanel == null)
        ? 0.0
        : baseSidePanelWidth;

    final availableBoardWidth = math.max(
      220.0,
      constraints.maxWidth - sidePanelWidth - evalSpace - (sidePanelWidth > 0 ? 38.0 : 24.0),
    );

    // Dynamic essential chrome height calculation
    const controlsBarHeight = 32.0;
    const verticalGutters = 8.0;
    final isMax = _sizeMode == WorkspaceSizeMode.max;
    final headerHeight = widget.header != null ? (isMax ? 32.0 : 44.0) : 0.0;
    final footerHeight = widget.footer != null ? (isMax ? 44.0 : 64.0) : 0.0;
    final availableBoardHeight = math.max(
      220.0,
      constraints.maxHeight - controlsBarHeight - verticalGutters - headerHeight - footerHeight,
    );

    final maxPossibleSquare = math.max(220.0, math.min(availableBoardWidth, availableBoardHeight));
    const minBoardSize = 220.0;

    final boardFraction = switch (_sizeMode) {
      WorkspaceSizeMode.auto => 0.94,
      WorkspaceSizeMode.fit => 1.0,
      WorkspaceSizeMode.max => 1.0,
      WorkspaceSizeMode.custom => _scaleFraction,
    };

    final boardSize = (minBoardSize + boardFraction * (maxPossibleSquare - minBoardSize)).clamp(minBoardSize, maxPossibleSquare);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dominant Board Section
          Expanded(
            child: Column(
              children: [
                // Top control bar with sizing slider & custom actions
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.customTopActions,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: sizingControlsBar,
                        ),
                      ),
                    ],
                  ),
                ),

                // Optional Workspace Header
                if (widget.header != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
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
                          const SizedBox(width: 10),
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

                // Optional Workspace Footer
                if (widget.footer != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: widget.footer!,
                  ),
              ],
            ),
          ),

          // Drag-resizable divider
          if (widget.sidePanel != null && !_isSidePanelCollapsed) ...[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  final cur = _draggedSidePanelWidth ?? baseSidePanelWidth;
                  final next = (cur - details.delta.dx).clamp(240.0, constraints.maxWidth * 0.45);
                  _draggedSidePanelWidth = next;
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: SizedBox(
                  width: 10,
                  child: Center(
                    child: Container(
                      width: 3,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.brd,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
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
    const minSquare = 200.0;
    final boardFraction = switch (_sizeMode) {
      WorkspaceSizeMode.auto => 0.88,
      WorkspaceSizeMode.fit => 1.0,
      WorkspaceSizeMode.max => 1.0,
      WorkspaceSizeMode.custom => _scaleFraction,
    };
    final boardSize = (minSquare + boardFraction * (maxSquare - minSquare)).clamp(minSquare, maxSquare);

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
    final maxSquare = math.min(boardHeight, constraints.maxWidth * 0.55 - evalSpace);
    const minSquare = 200.0;
    final boardFraction = switch (_sizeMode) {
      WorkspaceSizeMode.auto => 0.88,
      WorkspaceSizeMode.fit => 1.0,
      WorkspaceSizeMode.max => 1.0,
      WorkspaceSizeMode.custom => _scaleFraction,
    };
    final boardSize = (minSquare + boardFraction * (maxSquare - minSquare)).clamp(minSquare, maxSquare);

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
