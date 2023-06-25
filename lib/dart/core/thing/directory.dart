import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/property.dart';
import 'package:orginone/main.dart';

import 'application.dart';
import 'file_info.dart';
import 'form.dart';
import 'member.dart';
import 'species.dart';

class TaskModel {
  String? group;
  String? name;
  int? size;
  int? finished;
  DateTime? createTime;

  TaskModel({
    this.group,
    this.name,
    this.size,
    this.finished,
    this.createTime,
  });
}

typedef TaskChangeNotify = Function(List<TaskModel> taskList);

abstract class IDirectory extends IFileInfo<XDirectory> {
  //当前加载目录的用户
  late ITarget target;

  //上级目录
  IDirectory? parent;

  //下级文件系统项数组
  late List<IDirectory> children;

  //上传任务列表
  late List<TaskModel> taskList;

  //目录下的内容
  List<IFileInfo<XEntity>> content(int mode);

  //创建子目录
  Future<IDirectory?> create(DirectoryModel data);

  //更新目录
  Future<bool> update(DirectoryModel data);

  //删除目录
  Future<bool> delete();

  //目录下的文件
  late List<ISysFileInfo> files;

  //加载文件
  Future<List<ISysFileInfo>> loadFiles({bool reload = false});

  //上传文件
  Future<ISysFileInfo?> createFile(File file,{void Function(double)? progress});

  //目录下的表单
  late List<IForm> forms;

  //加载表单
  Future<List<IForm>> loadForms({bool reload = false});

  //新建表单
  Future<IForm?> createForm(FormModel data);

  //目录下的分类
  late List<ISpecies> specieses;

  //加载分类
  Future<List<ISpecies>> loadSpecieses({bool reload = false});

  //新建分类
  Future<ISpecies?> createSpecies(SpeciesModel data);

  //目录下的属性
  late List<IProperty> propertys;

  //加载属性
  Future<List<IProperty>> loadPropertys({bool reload = false});

  //新建属性
  Future<IProperty?> createProperty(PropertyModel data);

  //目录下的应用
  late List<IApplication> applications;

  //加载应用
  Future<List<IApplication>> loadApplications({bool reload = false});

  //新建应用
  Future<IApplication?> createApplication(ApplicationModel data);
}

class Directory extends FileInfo<XDirectory> implements IDirectory {
  Directory(XDirectory metadata, this.target,
      [this.parent, List<XDirectory>? directorys])
      : super(metadata..typeName = "目录", parent) {
    applications = [];
    files = [];
    forms = [];
    propertys = [];
    specieses = [];
    children = [];
    taskList = [];
    loadChildren(directorys);
  }

  @override
  late List<IApplication> applications;

  @override
  late List<IDirectory> children;

  @override
  late List<ISysFileInfo> files;

  @override
  late List<IForm> forms;

  @override
  IDirectory? parent;

  @override
  late List<IProperty> propertys;

  @override
  late List<ISpecies> specieses;

  @override
  late ITarget target;

  @override
  late List<TaskModel> taskList;

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    List<IFileInfo<XEntity>> cnt = [
      ...children,
      ...forms,
      ...applications,
      ...files,
    ];
    if (mode != 1) {
      cnt.addAll(propertys);
      cnt.addAll(specieses);
      if (parent == null) {
        cnt.addAll(target.targets.where((i) => i.id != target.id).toList());
        if (target is ICompany) {
          cnt.addAll((target as ICompany).stations);
          cnt.addAll((target as ICompany).identitys);
        }
        cnt.addAll(target.members.map((i) => Member(i, this)));
      }
    }
    cnt.sort((a, b) {
      return DateTime.parse(a.metadata.updateTime ?? "")
          .compareTo(DateTime.parse(b.metadata.updateTime ?? ""));
    });
    return cnt;
  }

  @override
  Future<bool> copy(IDirectory destination) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Future<IDirectory?> create(DirectoryModel data) async {
    data.parentId = id!;
    data.shareId = metadata.shareId!;
    var res = await kernel.createDirectory(data);
    if (res.success && res.data != null) {
      var directory = Directory(res.data!, target, this);
      children.add(directory);
      return directory;
    }
    return null;
  }

  @override
  Future<IApplication?> createApplication(ApplicationModel data) async{
    data.directoryId = id!;
    var res = await kernel.createApplication(data);
    if (res.success && res.data!=null) {
      var application = Application(res.data!, this);
      applications.add(application);
      return application;
    }
    return null;
  }

  @override
  Future<ISysFileInfo?> createFile(File file, {void Function(double)? progress}) async{
    progress?.call(0);
    final task = TaskModel(
      name: file.path.split('/').last,
      finished: 0,
      size: await file.length(),
      createTime: DateTime.now(),
    );
    taskList.add(task);
    final data = await kernel.anystore.fileUpdate(
      metadata.belongId!,
      file,
      '${id}/${file.path.split('/').last}',
         progress:  (pn) {
        task.finished = pn.toInt();
        progress?.call(pn);
      },
    );
    if (data != null) {
      final fileInfo = SysFileInfo(data, this);
      files.add(fileInfo);
      return fileInfo;
    }
    return null;
  }

  @override
  Future<IForm?> createForm(FormModel data) async{
    data.directoryId = id!;
    var res = await kernel.createForm(data);
    if (res.success && res.data!=null) {
      var form = Form(res.data!, this);
      forms.add(form);
      return form;
    }
    return null;
  }

  @override
  Future<IProperty?> createProperty(PropertyModel data) async{
    data.directoryId = id!;
    var res = await kernel.createProperty(data);
    if (res.success && res.data!=null) {
      var property =  Property(res.data!, this);
      propertys.add(property);
      return property;
    }
    return null;
  }

  @override
  Future<ISpecies?> createSpecies(SpeciesModel data) async{
    data.directoryId = id!;
    var res = await kernel.createSpecies(data);
    if (res.success && res.data!=null) {
      var species =  Species(res.data!, this);
      specieses.add(species);
      return species;
    }
    return null;
  }

  @override
  Future<bool> delete() async {
    if (parent != null) {
      final res = await kernel.deleteDirectory(IdReq(id: id!));
      if (res.success) {
        parent!.children.removeWhere((i) => i.id == id);
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<List<IApplication>> loadApplications({bool reload = false}) async{
    if (applications.isEmpty || reload) {
      final res = await kernel.queryApplications(IdReq(id: id!));
      if (res.success && res.data!=null) {
        final data = res.data!.result ?? [];
        applications = data
            .where((i) => i.parentId.isEmpty)
            .map((i) => Application(i, this, null, data))
            .toList();
      }
    }
    return applications;
  }

  @override
  Future<List<ISysFileInfo>> loadFiles({bool reload = false}) async {
    if (files.isEmpty || reload) {
      final res = await kernel.anystore.bucketOpreate(
          metadata.belongId!,
          BucketOpreateModel(
            key: formatKey(id!),
            operate: BucketOpreates.list,
          ));
      if (res.success && res.data!=null) {
        List<FileItemModel> data = [];

        res.data.forEach((json){
          data.add(FileItemModel.fromJson(json));
        });
        files = data
            .where((i) => !i.isDirectory)
            .map((item) => SysFileInfo(item, this))
            .toList();
      }
    }
    return files;
  }

  @override
  Future<List<IForm>> loadForms({bool reload = false}) async{
    if (forms.isEmpty || reload) {
      final res = await kernel.queryForms(IdReq(id: id!));
      if (res.success && res.data!=null) {
        forms = (res.data!.result ?? []).map((i) => Form(i, this)).toList();
      }
    }
    return forms;
  }

  @override
  Future<List<IProperty>> loadPropertys({bool reload = false}) async{
    if (propertys.isEmpty || reload) {
      final res = await kernel.queryPropertys(IdReq(id: id!));
      if (res.success && res.data!=null) {
        propertys = (res.data!.result ?? []).map((i) => Property(i, this)).toList();
      }
    }
    return propertys;
  }

  @override
  Future<List<ISpecies>> loadSpecieses({bool reload = false}) async{
    if (specieses.isEmpty || reload) {
      final res = await kernel.querySpecies(IdReq(id: id!));
      if (res.success && res.data!=null) {
        specieses = (res.data!.result ?? []).map((i) => Species(i, this)).toList();
      }
    }
    return specieses;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (parent != null &&
        destination.id != parent!.id &&
        destination.metadata.belongId == directory.metadata.belongId) {
      final success = await update(DirectoryModel.fromJson(metadata.toJson()));
      if (success) {
        directory.children.removeWhere((i) => i.id == id);
        parent = destination;
        directory = destination;
        destination.children.add(this);
      }
      return success;
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async {
    var data = DirectoryModel.fromJson(metadata.toJson());
    data.name = name;
    return await update(data);
  }

  @override
  Future<bool> update(DirectoryModel data) async {
    data.id = id!;
    data.parentId = metadata.parentId!;
    data.shareId = metadata.shareId!;
    var res = await kernel.updateDirectory(data);
    return res.success;
  }

  Future<void> loadSubDirectory() async {
    if (parent == null) {
      final res = await kernel.queryDirectorys(GetDirectoryModel(
        id: target.id,
        upTeam: target.metadata.typeName == TargetType.group.label,));
      if (res.success && res.data != null) {
        children = [];
        loadChildren(res.data!.result??[]);
      }
    }
  }


  loadChildren(List<XDirectory>? directorys) {
    if (directorys != null && directorys.isNotEmpty) {
      directorys.where((i) => i.parentId == id).forEach((i) {
        children.add(Directory(i, target, this, directorys));
      });
    }
  }

  @override
  Future<bool> loadContent({bool reload = false}) async{
    // TODO: implement loadContent
    if(reload){
      await loadSubDirectory();
      await loadFiles();
      await loadForms();
      await loadPropertys();
      await loadSpecieses();
      await loadApplications();
    }

    return false;
  }

  String formatKey(String key) {
    return base64.encode(utf8.encode(key));
  }
}