import "package:orginone/dart/base/api/kernelapi.dart";
import "package:orginone/dart/base/model.dart";
import "package:orginone/dart/base/schema.dart";
import "package:orginone/dart/core/market/index.dart";

/*
 * 应用资源操作
 */
class Resource implements IResource {
  late String teamId;
  late List<String> destIds;
  late String destType;
  @override
  late XResource resource;

  Resource(this.resource, XProduct prod) {
    resource.product = prod;
  }

  @override
  Future<bool> createExtend(
    String teamId,
    List<String> destIds,
    String destType,
  ) async {
    ResultType resultType = await KernelApi.getInstance().createSourceExtend(
        SourceExtendModel(
            sourceId: resource.id,
            sourceType: '资源',
            destType: destType,
            destIds: destIds,
            teamId: teamId,
            spaceId: resource.product!.belongId));

    return resultType.success;
  }

  @override
  Future<bool> deleteExtend(
    String teamId,
    List<String> destIds,
    String destType,
  ) async {
    return (await kernel.deleteSourceExtend(SourceExtendModel(
      sourceId: resource.id,
      sourceType: '资源',
      destIds: [],
      destType: destType,
      spaceId: resource.product!.belongId,
      teamId: teamId,
    )))
        .success;
  }

  @override
  Future<IdNameArray?> queryExtend(
    String destType,
    String? teamId,
  ) async {
    return (await kernel.queryExtendBySource(SearchExtendReq(
      sourceId: resource.id,
      sourceType: '资源',
      spaceId: resource.product!.belongId,
      destType: '',
      teamId: '',
    )))
        .data;
  } 
}