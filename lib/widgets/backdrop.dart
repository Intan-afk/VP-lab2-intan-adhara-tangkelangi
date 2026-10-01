import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/colors.dart';

const double _kFlingVelocity = 2.0;

const String _kMenuIconPath = 'assets/product/slanted_menu.png';
const String _kLogoIconPath = 'assets/diamond.png';

class _BrandIcon extends StatelessWidget {
  const _BrandIcon({required this.assetPath, required this.fallback});

  final String assetPath;
  final IconData fallback;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double size = iconTheme.size ?? 24.0;
    final Color? color = iconTheme.color;

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: BlendMode.srcIn,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return Icon(fallback, size: size, color: color);
          },
    );
  }
}

/// Lapisan depan (daftar produk) dengan sudut kiri-atas miring.
class _FrontLayer extends StatelessWidget {
  const _FrontLayer({this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(46.0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40.0,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Judul app bar dengan animasi ikon dan cross-fade antar judul.
class _BackdropTitle extends AnimatedWidget {
  const _BackdropTitle({
    required Animation<double> listenable,
    required this.onPress,
    required this.frontTitle,
    required this.backTitle,
  }) : super(listenable: listenable);

  final VoidCallback onPress;
  final Widget frontTitle;
  final Widget backTitle;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: listenable as Animation<double>,
      curve: const Interval(0.0, 0.78),
    );

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleLarge!,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: <Widget>[
          // Ikon bermerek: menu miring bergeser menjadi berlian
          SizedBox(
            width: 72.0,
            child: IconButton(
              padding: const EdgeInsets.only(right: 8.0),
              onPressed: onPress,
              icon: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: animation.value,
                    child: const _BrandIcon(
                      assetPath: _kMenuIconPath,
                      fallback: Icons.menu,
                    ),
                  ),
                  FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).evaluate(animation),
                    child: const _BrandIcon(
                      assetPath: _kLogoIconPath,
                      fallback: Icons.diamond_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Cross-fade antara backTitle dan frontTitle
          Stack(
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                  parent: ReverseAnimation(animation),
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0.5, 0.0),
                  ).evaluate(animation),
                  child: Semantics(
                    label: 'hide categories menu',
                    child: backTitle,
                  ),
                ),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: const Offset(-0.25, 0.0),
                    end: Offset.zero,
                  ).evaluate(animation),
                  child: Semantics(
                    label: 'show categories menu',
                    child: frontTitle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  const Backdrop({
    super.key,
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
  });

  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0, // 1.0 = lapisan depan terlihat
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);
    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _controller.fling(velocity: _kFlingVelocity);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
      velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity,
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    final Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        layerTop,
        0.0,
        layerTop - layerSize.height,
      ),
      end: RelativeRect.fill,
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          excluding: _frontLayerVisible,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      title: _BackdropTitle(
        listenable: _controller.view,
        onPress: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search, semanticLabel: 'search'),
          onPressed: () {
            // TODO: fitur pencarian
          },
        ),
        IconButton(
          icon: const Icon(Icons.tune, semanticLabel: 'filter'),
          onPressed: () {
            // TODO: fitur filter
          },
        ),
      ],
    );

    return Scaffold(
      backgroundColor: kShrinePink100,
      appBar: appBar,
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}
