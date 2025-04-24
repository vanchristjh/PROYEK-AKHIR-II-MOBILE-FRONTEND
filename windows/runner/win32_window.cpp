#include "win32_window.h"

#include <dwmapi.h>
#include <flutter_windows.h>

#include "resource.h"

namespace {

/// Window attribute that enables dark mode window decorations.
///
/// Redefined in case the developer's machine has a Windows SDK older than
/// version 10.0.22000.0.
/// See: https://docs.microsoft.com/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute
#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif

constexpr const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

/// Registry key for app theme preference.
///
/// A value of 0 indicates apps should use dark mode. A non-zero or missing
/// value indicates apps should use light mode.
constexpr const wchar_t kGetPreferredBrightnessRegKey[] =
  L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";
constexpr const wchar_t kGetPreferredBrightnessRegValue[] = L"AppsUseLightTheme";

// The number of Win32Window objects that currently exist.
static int g_active_window_count = 0;

using EnableNonClientDpiScaling = BOOL __stdcall(HWND hwnd);
void SetBoundsFromRect(HWND window, RECT* rect) {
// Scale helper to convert logical scaler values to physical using passed in
// scale factorrect->right - rect->left,
int Scale(int source, double scale_factor) {
  return static_cast<int>(source * scale_factor);
}

// Dynamically loads the |EnableNonClientDpiScaling| from the User32 module.
// This API is only needed for PerMonitor V1 awareness mode.
void EnableFullDpiSupportIfAvailable(HWND hwnd) {
  HMODULE user32_module = LoadLibraryA("User32.dll");
  if (!user32_module) {
    return;
  }Dynamically loads the |EnableNonClientDpiScaling| from the User32 module.
  auto enable_non_client_dpi_scaling =tor V1 awareness mode.
      reinterpret_cast<EnableNonClientDpiScaling*>(
          GetProcAddress(user32_module, "EnableNonClientDpiScaling"));
  if (enable_non_client_dpi_scaling != nullptr) {
    enable_non_client_dpi_scaling(hwnd);
  }
  FreeLibrary(user32_module);scaling =
}     reinterpret_cast<EnableNonClientDpiScaling*>(
          GetProcAddress(user32_module, "EnableNonClientDpiScaling"));
}  // namespacen_client_dpi_scaling != nullptr) {
    enable_non_client_dpi_scaling(hwnd);
// Manages the Win32Window's window class registration.
class WindowClassRegistrar {;
 public:
  ~WindowClassRegistrar() = default;
}  // namespace
  // Returns the singleton registrar instance.
  static WindowClassRegistrar* GetInstance() {stration.
    if (!instance_) {strar {
      instance_ = new WindowClassRegistrar();
    }ndowClassRegistrar() = default;
    return instance_;
  }/ Returns the singleton registrar instance.
  static WindowClassRegistrar* GetInstance() {
  // Returns the name of the window class, registering the class if it hasn't
  // previously been registered.sRegistrar();
  const wchar_t* GetWindowClass();
    return instance_;
  // Unregisters the window class. Should only be called if there are no
  // instances of the window.
  void UnregisterWindowClass();ndow class, registering the class if it hasn't
  // previously been registered.
 private:char_t* GetWindowClass();
  WindowClassRegistrar() = default;
  // Unregisters the window class. Should only be called if there are no
  static WindowClassRegistrar* instance_;
  void UnregisterWindowClass();
  bool class_registered_ = false;
};rivate:
  WindowClassRegistrar() = default;
WindowClassRegistrar* WindowClassRegistrar::instance_ = nullptr;
  static WindowClassRegistrar* instance_;
const wchar_t* WindowClassRegistrar::GetWindowClass() {
  if (!class_registered_) {false;
    WNDCLASS window_class{};
    window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
    window_class.lpszClassName = kWindowClassName;ce_ = nullptr;
    window_class.style = CS_HREDRAW | CS_VREDRAW;
    window_class.cbClsExtra = 0;rar::GetWindowClass() {
    window_class.cbWndExtra = 0;
    window_class.hInstance = GetModuleHandle(nullptr);
    window_class.hIcon = = LoadCursor(nullptr, IDC_ARROW);
        LoadIcon(window_class.hInstance, MAKEINTRESOURCE(IDI_APP_ICON));
    window_class.hbrBackground = 0; | CS_VREDRAW;
    window_class.lpszMenuName = nullptr;
    window_class.lpfnWndProc = Win32Window::WndProc;
    RegisterClass(&window_class);oduleHandle(nullptr);
    class_registered_ = true;
  }     LoadIcon(window_class.hInstance, MAKEINTRESOURCE(IDI_APP_ICON));
  return kWindowClassName;ound = 0;
}   window_class.lpszMenuName = nullptr;
    window_class.lpfnWndProc = Win32Window::WndProc;
void WindowClassRegistrar::UnregisterWindowClass() {
  UnregisterClass(kWindowClassName, nullptr);
  class_registered_ = false;
} return kWindowClassName;
}
Win32Window::Win32Window() {
  ++g_active_window_count;:UnregisterWindowClass() {
} UnregisterClass(kWindowClassName, nullptr);
  class_registered_ = false;
Win32Window::~Win32Window() {
  --g_active_window_count;
  Destroy();:Win32Window() {
} ++g_active_window_count;
}
bool Win32Window::Create(const std::wstring& title,
                         const Point& origin,
                         const Size& size) {
  Destroy();
}
  const wchar_t* window_class =
      WindowClassRegistrar::GetInstance()->GetWindowClass();
                         const Point& origin,
  const POINT target_point = {static_cast<LONG>(origin.x),
                              static_cast<LONG>(origin.y)};
  HMONITOR monitor = MonitorFromPoint(target_point, MONITOR_DEFAULTTONEAREST);
  UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
  double scale_factor = dpi / 96.0;ance()->GetWindowClass();

  HWND window = CreateWindow({static_cast<LONG>(origin.x),
      window_class, title.c_str(), WS_OVERLAPPEDWINDOW,y)};
      Scale(origin.x, scale_factor), Scale(origin.y, scale_factor),TONEAREST);
      Scale(size.width, scale_factor), Scale(size.height, scale_factor),
      nullptr, nullptr, GetModuleHandle(nullptr), this);

  if (!window) {CreateWindow(
    return false;s, title.c_str(), WS_OVERLAPPEDWINDOW,
  }   Scale(origin.x, scale_factor), Scale(origin.y, scale_factor),
      Scale(size.width, scale_factor), Scale(size.height, scale_factor),
  UpdateTheme(window);, GetModuleHandle(nullptr), this);

  return OnCreate();
}   return false;
  }
bool Win32Window::Show() {
  return ShowWindow(window_handle_, SW_SHOWNORMAL);
}
  return OnCreate();
// static
LRESULT CALLBACK Win32Window::WndProc(HWND const window,
                                      UINT const message,
                                      WPARAM const wparam,
                                      LPARAM const lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto window_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,const window,
                     reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));
                                      WPARAM const wparam,
    auto that = static_cast<Win32Window*>(window_struct->lpCreateParams);
    EnableFullDpiSupportIfAvailable(window);
    that->window_handle_ = window;et_cast<CREATESTRUCT*>(lparam);
  } else if (Win32Window* that = GetThisFromHandle(window)) {
    return that->MessageHandler(window, message, wparam, lparam);CreateParams));
  }
    auto that = static_cast<Win32Window*>(window_struct->lpCreateParams);
  return DefWindowProc(window, message, wparam, lparam);
}   that->window_handle_ = window;
  } else if (Win32Window* that = GetThisFromHandle(window)) {
LRESULTurn that->MessageHandler(window, message, wparam, lparam);
Win32Window::MessageHandler(HWND hwnd,
                            UINT const message,
                            WPARAM const wparam,lparam);
                            LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY:
      window_handle_ = nullptr;D hwnd,
      Destroy();            UINT const message,
      if (quit_on_close_) { WPARAM const wparam,
        PostQuitMessage(0); LPARAM const lparam) noexcept {
      }h (message) {
      return 0;TROY:
      window_handle_ = nullptr;
    case WM_DPICHANGED: {
      auto newRectSize = reinterpret_cast<RECT*>(lparam);
      LONG newWidth = newRectSize->right - newRectSize->left;
      LONG newHeight = newRectSize->bottom - newRectSize->top;
      return 0;
      SetWindowPos(hwnd, nullptr, newRectSize->left, newRectSize->top, newWidth,
                   newHeight, SWP_NOZORDER | SWP_NOACTIVATE);
      auto newRectSize = reinterpret_cast<RECT*>(lparam);
      return 0;FromRect(hwnd, newRectSize);
    } return 0;
    case WM_SIZE: {
      RECT rect = GetClientArea();
      if (child_content_ != nullptr) {
        // Size and position the child window.
        MoveWindow(child_content_, rect.left, rect.top, rect.right - rect.left,
                   rect.bottom - rect.top, TRUE);t.top, rect.right - rect.left,
      }            rect.bottom - rect.top, TRUE);
      return 0;
    } return 0;
    }
    case WM_ACTIVATE:
      if (child_content_ != nullptr) {
        SetFocus(child_content_);tr) {
      } SetFocus(child_content_);
      return 0;
      return 0;
    case WM_DWMCOLORIZATIONCOLORCHANGED:
      UpdateTheme(hwnd);IONCOLORCHANGED:
      return 0;me(hwnd);
  }   return 0;
  }
  return DefWindowProc(window_handle_, message, wparam, lparam);
} return DefWindowProc(window_handle_, message, wparam, lparam);
}
void Win32Window::Destroy() {
  OnDestroy();ow::Destroy() {
  OnDestroy();
  if (window_handle_) {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;le_);
  } window_handle_ = nullptr;
  if (g_active_window_count == 0) {
    WindowClassRegistrar::GetInstance()->UnregisterWindowClass();
  } WindowClassRegistrar::GetInstance()->UnregisterWindowClass();
} }
}
Win32Window* Win32Window::GetThisFromHandle(HWND const window) noexcept {
  return reinterpret_cast<Win32Window*>(dle(HWND const window) noexcept {
      GetWindowLongPtr(window, GWLP_USERDATA));
}     GetWindowLongPtr(window, GWLP_USERDATA));
}
void Win32Window::SetChildContent(HWND content) {
  child_content_ = content;ontent(HWND content) {
  SetParent(content, window_handle_);
  RECT frame = GetClientArea();dle_);
  RECT frame = GetClientArea();
  MoveWindow(content, frame.left, frame.top, frame.right - frame.left,
             frame.bottom - frame.top, true);frame.right - frame.left,
             frame.bottom - frame.top, true);
  SetFocus(child_content_);
} SetFocus(child_content_);
}
RECT Win32Window::GetClientArea() {
  RECT frame;dow::GetClientArea() {
  GetClientRect(window_handle_, &frame);
  return frame;(window_handle_, &frame);
} return frame;
}
HWND Win32Window::GetHandle() {
  return window_handle_;dle() {
} return window_handle_;
}
void Win32Window::SetQuitOnClose(bool quit_on_close) {
  quit_on_close_ = quit_on_close;bool quit_on_close) {
} quit_on_close_ = quit_on_close;
}
bool Win32Window::OnCreate() {
  // No-op; provided for subclasses.
  return true;ovided for subclasses.
} return true;
}
void Win32Window::OnDestroy() {
  // No-op; provided for subclasses.
} // No-op; provided for subclasses.
}
void Win32Window::UpdateTheme(HWND const window) {
  DWORD light_mode;pdateTheme(HWND const window) {
  DWORD light_mode_size = sizeof(light_mode);
  LSTATUS result = RegGetValue(HKEY_CURRENT_USER, kGetPreferredBrightnessRegKey,
                               kGetPreferredBrightnessRegValue,BrightnessRegKey,
                               RRF_RT_REG_DWORD, nullptr, &light_mode,
                               &light_mode_size);nullptr, &light_mode,
                               &light_mode_size);
  if (result == ERROR_SUCCESS) {
    BOOL enable_dark_mode = light_mode == 0;
    DwmSetWindowAttribute(window, DWMWA_USE_IMMERSIVE_DARK_MODE,
                          &enable_dark_mode, sizeof(enable_dark_mode));
  }                       &enable_dark_mode, sizeof(enable_dark_mode));
} }

void Win32Window::SetBounds(RECT* bounds) {
  SetWindowPos(
      window_handle_, nullptr,
      bounds->left, bounds->top,
      bounds->right - bounds->left, bounds->bottom - bounds->top,
      SWP_NOZORDER | SWP_NOACTIVATE);
}

}