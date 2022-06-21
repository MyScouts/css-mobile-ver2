import 'package:flutter_application_1/src/resource/response/customer_response.dart';
import 'package:flutter_application_1/src/resource/response/login_response.dart';
import 'package:flutter_application_1/src/resource/response/product_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'data_service.g.dart';

@RestApi(
    baseUrl: "https://happy-bee-api.azurewebsites.net/api/v3.0/collaborator/")
abstract class DataService {
  factory DataService(Dio dio) = _DataService;

  @POST("login")
  Future<LoginResponse> login(@Query("loginToken") String firebaseToken,
      @Query("registrationToken") String registrationToken);

// CUSTOMER

  @POST('customer/new')
  Future<String> createCustomer(
      @Header("Authorization") String? token, @Body() dynamic request);
  @GET("customer/list")
  Future<List<CustomerData>> getCustomers(
      @Header("Authorization") String? token);

  @GET("customer/get/{customerId}")
  Future<CustomerData> getCustomer(
      @Header("Authorization") String? token, @Path("customerId") String id);

  @PUT("customer/update")
  Future<String> updateCustomer(
      @Header("Authorization") String? token, @Body() dynamic request);

// END CUSTOMER

// PRODUCT

  @GET("product/list")
  Future<ListProductResponse> getProducts(
    @Header("Authorization") String? token,
    @Query("page_number") int? page,
    @Query("page_size") int? pageSize,
    @Query("status") String? status,
    @Query("pointSale") int? pointSale,
    @Query("price") String? price,
    @Query("inStock") String? inStock,
    @Query("brand") String? brand,
    @Query("productName") String? productName,
  );

  @GET("product/get/{id}")
  Future<ProductData> getProductDetail(
    @Header("Authorization") String? token,
    @Path("id") String id,
  );
}
