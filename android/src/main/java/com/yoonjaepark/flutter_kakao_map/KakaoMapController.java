// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import net.daum.android.map.MapEnvironmentType;
import net.daum.mf.map.api.CameraPosition;
import net.daum.mf.map.api.CameraUpdate;
import net.daum.mf.map.api.MapPOIItem;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapPointBounds;
import net.daum.mf.map.api.MapView;

import org.json.JSONObject;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin.CREATED;
import static com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin.DESTROYED;
import static com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin.PAUSED;
import static com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin.RESUMED;
import static com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin.STARTED;
import static com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin.STOPPED;

public class KakaoMapController
        implements Application.ActivityLifecycleCallbacks,
        DefaultLifecycleObserver,
        ActivityPluginBinding.OnSaveInstanceStateListener,
        KakaoMapOptionsSink,
        MethodChannel.MethodCallHandler,
        KakaoMapListener,
        PlatformView {

    private static final String TAG = "########KakaoMap";
    private final int id;
    private final AtomicInteger activityState;
    private final MethodChannel methodChannel;
    private final KakaoMapOptions options;
    private MapView mapView;
    private final SurfaceHolder surfaceHolder;
    private final Activity activity;
    private boolean trackCameraPosition = false;
    private boolean myLocationEnabled = false;
    private boolean myLocationButtonEnabled = false;
    private boolean zoomControlsEnabled = true;
    private boolean indoorEnabled = true;
    private boolean trafficEnabled = false;
    private boolean buildingsEnabled = true;
    private boolean disposed = false;
    private final float density;
    private MethodChannel.Result mapReadyResult;
    private final int activityHashCode;
    private final Lifecycle lifecycle;
    private final Context context;
    private final Application mApplication;
    private final PluginRegistry.Registrar registrar; // For v1 embedding only.
    private double lat;
    private double lan;
    private int zoomLevel;
    private final MarkersController markersController;
    private List<Object> initialMarkers;
    private List<Object> initialPolygons;
    private List<Object> initialPolylines;
    private List<Object> initialCircles;
    private FrameLayout frameLayout;
    private boolean animate = true;

    KakaoMapController(
            int id,
            Context context,
            AtomicInteger activityState,
            BinaryMessenger binaryMessenger,
            Application application,
            Lifecycle lifecycle,
            PluginRegistry.Registrar registrar,
            int registrarActivityHashCode,
            KakaoMapOptions options,
            Activity activity) {

//        this.getHashKey(context);
        this.options = options;
        this.id = id;
        this.context = context;
        this.activityState = activityState;

        this.mapView = new MapView(activity);
        this.surfaceHolder = mapView.getHolder();

        this.density = context.getResources().getDisplayMetrics().density;
        methodChannel = new MethodChannel(binaryMessenger, "plugins.flutter.io/kakao_maps_" + id);
        methodChannel.setMethodCallHandler(this);
        mApplication = application;
        this.lifecycle = lifecycle;
        this.registrar = registrar;
        this.activityHashCode = registrarActivityHashCode;
        this.activity = activity;
        setKakaoMapListener(this);
        this.getHashKey(context);

        this.markersController = new MarkersController(methodChannel);
    }

    private void getHashKey(Context context){
        PackageInfo packageInfo = null;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_SIGNATURES);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        if (packageInfo == null)
            Log.e("KeyHash", "KeyHash:null");

        for (Signature signature : packageInfo.signatures) {
            try {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
                Log.d("KeyHash", Base64.encodeToString(md.digest(), Base64.DEFAULT));
            } catch (NoSuchAlgorithmException e) {
                Log.e("KeyHash", "Unable to get MessageDigest. signature=" + signature, e);
            }
        }
    }

    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {

    }

    @Override
    public void onFlutterViewDetached() {

    }


    void init() {
        switch (activityState.get()) {
            case STOPPED:
                break;
            case PAUSED:
                break;
            case RESUMED:
                break;
            case STARTED:
                break;
            case CREATED:
                break;
            case DESTROYED:
                break;
            default:
                throw new IllegalArgumentException(
                        "Cannot interpret " + activityState.get() + " as an activity state");
        }
        if (lifecycle != null) {
            lifecycle.addObserver(this);
        } else {
            getApplication().registerActivityLifecycleCallbacks(this);
        }
    }

    private void moveCamera(CameraUpdate cameraUpdate) {
        mapView.moveCamera(cameraUpdate);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "map#waitForMap":
                if (mapView != null) {
                    result.success(null);
                    return;
                }
                mapReadyResult = result;
                break;
            case "map#update":
            {
                Convert.interpretKakaoMapOptions(call.argument("options"), this);
                break;
            }
            case "map#clearMapTilePersistentCache":
            {
                MapView.clearMapTilePersistentCache();
            }
            case "map#zoomIn":
            {
                mapView.zoomIn(true);
                break;
            }
            case "map#zoomOut":
            {
                mapView.zoomOut(false);
                break;
            }
            case "map#getMapCenterPoint":
            {
                Log.d("TEST", mapView.toString());
                if (mapView != null) {
                    MapPoint latLng = mapView.getMapCenterPoint();
                    result.success(Convert.mapPointToJson(latLng));
                } else {
                    result.error(
                            "KakaoMap uninitialized", "getMapCenterPoint called prior to map initialization", null);
                }
                break;
            }
            case "camera#move":
            {
                final CameraUpdate cameraUpdate = Convert.toCameraUpdate(call.argument("cameraUpdate"), density);
                moveCamera(cameraUpdate);
                result.success(null);
                break;
            }
            case "camera#animate":
            {
                this.animate = true;
                result.success(null);
                break;
            }
            case "markers#update":
            {
                Object markersToAdd = call.argument("markersToAdd");
                markersController.addMarkers((List<Object>) markersToAdd);
                Object markersToChange = call.argument("markersToChange");
                markersController.changeMarkers((List<Object>) markersToChange);
                Object markerIdsToRemove = call.argument("markerIdsToRemove");
                markersController.removeMarkers((List<Object>) markerIdsToRemove);
                result.success(null);
                break;
            }
            case "markers#showInfoWindow":
            {
                break;
            }
            case "markers#hideInfoWindow":
            {
                break;
            }
            case "markers#isInfoWindowShown":
            {
                break;
            }
            case "circles#update":
            {
                result.success(null);
                break;
            }
            case "map#isCompassEnabled":
            {
                mapView.setCurrentLocationTrackingMode(MapView.CurrentLocationTrackingMode.TrackingModeOnWithHeading);
                break;
            }
            case "map#getMinMaxZoomLevels":
            {
                break;
            }
            case "map#isZoomGesturesEnabled":
            {
                break;
            }
            case "map#isZoomControlsEnabled":
            {
                break;
            }
            case "map#isScrollGesturesEnabled":
            {
                break;
            }
            case "map#isTiltGesturesEnabled":
            {
                break;
            }
            case "map#isRotateGesturesEnabled":
            {
                break;
            }
            case "map#isMyLocationButtonEnabled":
            {
                break;
            }
            case "map#isTrafficEnabled":
            {
                break;
            }
            case "map#isBuildingsEnabled":
            {
                break;
            }
            case "map#getZoomLevel":
            {
                result.success(mapView.getZoomLevel());
                break;
            }
            case "map#setStyle":
            {
                break;
            }
            default:
                result.notImplemented();
        }
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        methodChannel.setMethodCallHandler(null);
        setKakaoMapListener(null);
        getApplication().unregisterActivityLifecycleCallbacks(this);
    }


    private void setKakaoMapListener(@Nullable KakaoMapListener listener) {
        mapView.setCurrentLocationEventListener(listener);
        mapView.setMapViewEventListener(listener);
        mapView.setOpenAPIKeyAuthenticationResultListener(listener);
        mapView.setPOIItemEventListener(listener);
    }

    // @Override
    // The minimum supported version of Flutter doesn't have this method on the PlatformView interface, but the maximum
    // does. This will override it when available even with the annotation commented out.
    public void onInputConnectionLocked() {
        // TODO(mklim): Remove this empty override once https://github.com/flutter/flutter/issues/40126 is fixed in stable.
    };

    // @Override
    // The minimum supported version of Flutter doesn't have this method on the PlatformView interface, but the maximum
    // does. This will override it when available even with the annotation commented out.
    public void onInputConnectionUnlocked() {
        // TODO(mklim): Remove this empty override once https://github.com/flutter/flutter/issues/40126 is fixed in stable.
    };

    // Application.ActivityLifecycleCallbacks methods
    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
        mapView.onResume();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
        mapView.onPause();
    }

    @Override
    public void onActivityStopped(Activity activity) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        if (disposed || activity.hashCode() != getActivityHashCode()) {
            return;
        }
    }

    // DefaultLifecycleObserver and OnSaveInstanceStateListener

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
        mapView.onResume();
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
        mapView.onResume();
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onRestoreInstanceState(Bundle bundle) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onSaveInstanceState(Bundle bundle) {
        if (disposed) {
            return;
        }
    }

    private void updateInitialMarkers() {
        markersController.addMarkers(initialMarkers);
    }

    @SuppressLint("MissingPermission")
    private void updateMyLocationSettings() {
        if (hasLocationPermission()) {
            // The plugin doesn't add the location permission by default so that apps that don't need
            // the feature won't require the permission.
            // Gradle is doing a static check for missing permission and in some configurations will
            // fail the build if the permission is missing. The following disables the Gradle lint.
            //noinspection ResourceType
        } else {
            // TODO(amirh): Make the options update fail.
            // https://github.com/flutter/flutter/issues/24327
            Log.e(TAG, "Cannot enable MyLocation layer as location permissions are not granted");
        }
    }

    private boolean hasLocationPermission() {
        return checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED
                || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
                == PackageManager.PERMISSION_GRANTED;
    }

    private int checkSelfPermission(String permission) {
        if (permission == null) {
            throw new IllegalArgumentException("permission is null");
        }
        return context.checkPermission(
                permission, android.os.Process.myPid(), android.os.Process.myUid());
    }

    private int getActivityHashCode() {
        if (registrar != null && registrar.activity() != null) {
            return registrar.activity().hashCode();
        } else {
            return activityHashCode;
        }
    }

    private Application getApplication() {
        if (registrar != null && registrar.activity() != null) {
            return registrar.activity().getApplication();
        } else {
            return mApplication;
        }
    }

    public void setMapCenterPointAndZoomLevel(CameraPosition cameraPosition) {
        mapView.setMapCenterPointAndZoomLevel(cameraPosition.target, Convert.toInt(cameraPosition.zoomLevel), true);
    }

    @Override
    public void setCameraTargetBounds(MapPointBounds bounds) {

    }

    @Override
    public void setCompassEnabled(boolean compassEnabled) {

    }

    @Override
    public void setMapToolbarEnabled(boolean setMapToolbarEnabled) {

    }

    @Override
    public void setMapType(int mapType) {
        MapView.MapType[] mapTypes = MapView.MapType.values();
        mapView.setMapType(mapTypes[mapType]);
    }

    @Override
    public void setCurrentLocationTrackingMode(int currentLocationTrackingMode) {
        MapView.CurrentLocationTrackingMode[] trackingModes = MapView.CurrentLocationTrackingMode.values();
        MapView.CurrentLocationTrackingMode trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOff;
        mapView.setShowCurrentLocationMarker(true);
        if (currentLocationTrackingMode == 0) {
            trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOff;
        } else if (currentLocationTrackingMode == 1) {
            trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOnWithoutHeading;
        } else if (currentLocationTrackingMode == 2) {
            trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOnWithHeading;

        } else if (currentLocationTrackingMode == 3) {
            trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOnWithoutHeadingWithoutMapMoving;

        } else if (currentLocationTrackingMode == 4) {
            trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOnWithHeadingWithoutMapMoving;

        } else if (currentLocationTrackingMode == 5) {
            trackingMode = MapView.CurrentLocationTrackingMode.TrackingModeOnWithMarkerHeadingWithoutMapMoving;
        }
//
        mapView.setCurrentLocationTrackingMode(trackingMode);
    }

    @Override
    public void setHdMapTile(boolean hdMapTileEnabled) {
        mapView.setHDMapTileEnabled(hdMapTileEnabled);
    }

    @Override
    public void setMinMaxZoomPreference(Float min, Float max) {

    }

    @Override
    public void setPadding(float top, float left, float bottom, float right) {

    }

    @Override
    public void setRotateGesturesEnabled(boolean rotateGesturesEnabled) {

    }

    @Override
    public void setScrollGesturesEnabled(boolean scrollGesturesEnabled) {

    }

    @Override
    public void setTiltGesturesEnabled(boolean tiltGesturesEnabled) {

    }

    @Override
    public void setTrackCameraPosition(boolean trackCameraPosition) {

    }

    @Override
    public void setZoomGesturesEnabled(boolean zoomGesturesEnabled) {

    }

    @Override
    public void setMyLocationEnabled(boolean myLocationEnabled) {

    }

    @Override
    public void setZoomControlsEnabled(boolean zoomControlsEnabled) {

    }

    @Override
    public void setMyLocationButtonEnabled(boolean myLocationButtonEnabled) {

    }

    public void setIndoorEnabled(boolean indoorEnabled) {
        this.indoorEnabled = indoorEnabled;
    }

    public void setTrafficEnabled(boolean trafficEnabled) {
    }

    public void setBuildingsEnabled(boolean buildingsEnabled) {
        this.buildingsEnabled = buildingsEnabled;
    }

    @Override
    public void setInitialMarkers(Object initialMarkers) {
        this.initialMarkers = (List<Object>) initialMarkers;
        if (mapView != null) {
            updateInitialMarkers();
        }
    }

    @Override
    public void setInitialPolygons(Object initialPolygons) {

    }

    @Override
    public void setInitialPolylines(Object initialPolylines) {

    }

    @Override
    public void setInitialCircles(Object initialCircles) {

    }

    private SurfaceHolder.Callback surfaceListener = new SurfaceHolder.Callback() {


        @Override
        public void surfaceCreated(SurfaceHolder surfaceHolder) {
            surfaceHolder.setFormat(PixelFormat.TRANSPARENT);
        }

        @Override
        public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i1, int i2) {
        }

        @Override
        public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        }
    };

    // 단말의 방향(Heading) 각도값을 통보받을 수 있다.
    @Override
    public void onCurrentLocationDeviceHeadingUpdate(MapView mapView, float v) {

    }

    @Override
    public void onCurrentLocationUpdateFailed(MapView mapView) {

    }

    @Override
    public void onCurrentLocationUpdateCancelled(MapView mapView) {

    }

    @Override
    public void onMapViewInitialized(MapView mapView) {
//        mapView.setMapCenterPoint(this.let);
    }

    @Override
    public void onCurrentLocationUpdate(MapView mapView, MapPoint mapPoint, float accuracy) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("position", Convert.mapPointToJson(mapPoint));
        arguments.put("accuracy", accuracy);
        methodChannel.invokeMethod("camera#onCurrentLocationUpdate", arguments);
    }

    @Override
    public void onMapViewCenterPointMoved(MapView mapView, MapPoint mapPoint) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("position", Convert.mapPointToJson(mapPoint));
        methodChannel.invokeMethod("camera#onMove", arguments);
    }

    @Override
    public void onMapViewZoomLevelChanged(MapView mapView, int i) {

    }

    @Override
    public void onMapViewSingleTapped(MapView mapView, MapPoint mapPoint) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("position", Convert.mapPointToJson(mapPoint));
        methodChannel.invokeMethod("map#onTap", arguments);
    }

    @Override
    public void onMapViewDoubleTapped(MapView mapView, MapPoint mapPoint) {

    }

    @Override
    public void onMapViewLongPressed(MapView mapView, MapPoint mapPoint) {
        final Map<String, Object> arguments = new HashMap<>(2);
        arguments.put("position", Convert.mapPointToJson(mapPoint));
        methodChannel.invokeMethod("map#onLongPress", arguments);
    }

    @Override
    public void onMapViewDragStarted(MapView mapView, MapPoint mapPoint) {

    }

    @Override
    public void onMapViewDragEnded(MapView mapView, MapPoint mapPoint) {

    }

    @Override
    public void onMapViewMoveFinished(MapView mapView, MapPoint mapPoint) {

    }

    @Override
    public void onDaumMapOpenAPIKeyAuthenticationResult(MapView mapView, int i, String s) {
        mapView.setMapCenterPointAndZoomLevel(this.options.initialCameraPosition.target, 3, true);
        markersController.setKakaoMap(mapView);
    }

    @Override
    public void onPOIItemSelected(MapView mapView, MapPOIItem mapPOIItem) {
        markersController.onMarkerTap(mapPOIItem.getUserObject().toString());
    }

    @Override
    public void onCalloutBalloonOfPOIItemTouched(MapView mapView, MapPOIItem mapPOIItem) {

    }

    @Override
    public void onCalloutBalloonOfPOIItemTouched(MapView mapView, MapPOIItem mapPOIItem, MapPOIItem.CalloutBalloonButtonType calloutBalloonButtonType) {

    }

    @Override
    public void onDraggablePOIItemMoved(MapView mapView, MapPOIItem mapPOIItem, MapPoint mapPoint) {

    }
}

interface KakaoMapListener
        extends MapView.CurrentLocationEventListener,
        MapView.MapViewEventListener,
        MapView.OpenAPIKeyAuthenticationResultListener,
        MapView.POIItemEventListener {}