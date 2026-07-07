// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_checklist_master_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ipalChecklistTemplates)
final ipalChecklistTemplatesProvider = IpalChecklistTemplatesProvider._();

final class IpalChecklistTemplatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IpalChecklistTemplate>>,
          List<IpalChecklistTemplate>,
          FutureOr<List<IpalChecklistTemplate>>
        >
    with
        $FutureModifier<List<IpalChecklistTemplate>>,
        $FutureProvider<List<IpalChecklistTemplate>> {
  IpalChecklistTemplatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ipalChecklistTemplatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ipalChecklistTemplatesHash();

  @$internal
  @override
  $FutureProviderElement<List<IpalChecklistTemplate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<IpalChecklistTemplate>> create(Ref ref) {
    return ipalChecklistTemplates(ref);
  }
}

String _$ipalChecklistTemplatesHash() =>
    r'cc44df596105bffdd5377a3e9b7b943f1745f4e5';
