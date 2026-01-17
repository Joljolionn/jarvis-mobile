import 'package:flutter/material.dart';

class SlidingFilter extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onTap;

  const SlidingFilter({
    super.key,
    required this.selectedFilter,
    required this.onTap,
  });

  @override
  State<SlidingFilter> createState() => _SlidingFilterState();
}

class _SlidingFilterState extends State<SlidingFilter> {
  double _dragValue = 0.0;
  bool _isDragging = false;

  @override
  void didUpdateWidget(SlidingFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging) {
      _syncPillToFilter();
    }
  }

  void _syncPillToFilter() {
    setState(() {
      if (widget.selectedFilter == "all") {
        _dragValue = 0.0;
      } else if (widget.selectedFilter == "pending") {
        _dragValue = 0.5;
      } else {
        _dragValue = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF2F2F7),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double totalWidth = constraints.maxWidth;
            double optionWidth = totalWidth / 3;

            double maxScroll = totalWidth - optionWidth;
            double currentLeft = _dragValue * maxScroll;

            return GestureDetector(
              onHorizontalDragStart: (_) => _isDragging = true,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragValue += details.primaryDelta! / maxScroll;
                  _dragValue = _dragValue.clamp(0.0, 1.0);
                });
              },
              onHorizontalDragEnd: (details) {
                _isDragging = false;
                if (_dragValue < 0.25) {
                  widget.onTap("all");
                } else if (_dragValue < 0.75) {
                  widget.onTap("pending");
                } else {
                  widget.onTap("completed");
                }
                _syncPillToFilter();
              },
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: _isDragging ? 100 : 300),
                    curve: Curves.easeOutCubic,
                    left: currentLeft,
                    top: 2,
                    bottom: 2,
                    width: optionWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _filterOption("Todos", "all"),
                      _filterOption("Pendentes", "pending"),
                      _filterOption("Completos", "completed"),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _filterOption(String text, String value) {
    bool isSelected = widget.selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(value),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}

