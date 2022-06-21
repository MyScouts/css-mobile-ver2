import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_application_1/src/resource/data/error_handler.dart';
import 'package:flutter_application_1/src/resource/data/failure.dart';
import 'package:flutter_application_1/src/resource/repository/local_reponsitory.dart';
import 'package:flutter_application_1/src/resource/request/create_customer_request.dart';
import 'package:flutter_application_1/src/resource/response/customer_response.dart';
import 'package:flutter_application_1/src/resource/services/data_service.dart';

abstract class CustomerRepository {
  Future<Either<Failure, String>> createCustomer(CreateCustomerRequest request);
  Future<Either<Failure, List<CustomerData>>> getCustomers();
  Future<Either<Failure, CustomerData>> getCustomer(String id);
}

class CustomerRepositoryImpl implements CustomerRepository {
  final DataService _dataService;
  final LocalRepository _localRepository;

  CustomerRepositoryImpl(this._dataService, this._localRepository);

  @override
  Future<Either<Failure, String>> createCustomer(
      CreateCustomerRequest request) async {
    try {
      final token = await _localRepository.getToken();
      final userId = await _localRepository.getUserId();
      final data = {
        "name": request.name,
        "phone": request.phone,
        "address": request.address,
        "description": request.description,
        "dob": request.dob,
        "accountCreator": {"id": userId}
      };

      final response = await _dataService.createCustomer(token, data);
      return Right(response);
    } on DioError catch (e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      Failure failure = ErrorHandler.handle(e).failure;
      failure.message = data["message"];
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<CustomerData>>> getCustomers() async {
    try {
      final token = await _localRepository.getToken();
      List<CustomerData> customers = await _dataService.getCustomers(token);
      return Right(customers);
    } on DioError catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, CustomerData>> getCustomer(String id) async {
    try {
      final token = await _localRepository.getToken();
      CustomerData customer = await _dataService.getCustomer(token, id);
      return Right(customer);
    } on DioError catch (e) {
      log("getCustomer: ${e.response?.data}");
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
