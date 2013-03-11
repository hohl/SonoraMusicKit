## Sonora Music Kit

An all-in-one solution for building content rich music applications by supporting the most popular streaming and radio sources.

Sonora Music Kit is based on the open source project [SNRMusicKit](https://github.com/indragiek/SNRMusicKit) by [Indragie Karunaratne](https://github.com/indragiek) which should have become the backend of the [Sonora App for Mac OS X](http://getsonora.com). 
This fork contains a couple of additions, some code refactoring, restructuring of the so far large single-library project into multiple smaller libraries and support for CocoaPods. It is designed to be used in the [Gesture & Voice Controlled Music Player App for iOS](http://www.michaelhohl.net/autoradio/) by [Michael Hohl](http://www.michaelhohl.net/).

This framework will consist of the following components that will create an all-in-one solution for building content rich music applications:

* **Content Sources**: Services and applications that will provide content.
* **Players**: Different audio players sharing a common interface to handle a wide variety of content formats. 
* **Other Services**: Objective-C interfaces to other commonly used services like Last.fm.

### How To Get Started

It is highly recommended to use CocoaPods for dependency management. If you are new to CocoaPods [read their wiki to get started](https://github.com/CocoaPods/CocoaPods/wiki/Creating-a-project-that-uses-CocoaPods).

To import the complete Sonora Music Kit library just add `pod 'SonoraMusicKit'` to your Podfile. If you just want to select single content sources of the project use it like `pod 'SonoraMusicKit/Spotify'` or `pod 'SonoraMusicKit/MPMediaLibrary'`.


### Progress

#### Content Sources

<table>
  <tr>
    <th>Name</th><th>iOS</th><th>Mac</th><th>Implemented</th>
  </tr>
  <tr>
    <td>iTunes</td><td>✘</td><td>✔</td><td>✝</td>
  </tr>
  <tr>
    <td>MPMediaLibrary</td><td>✔</td><td>✘</td><td>✔</td>
  </tr>
  <tr>
    <td>Spotify</td><td>✔</td><td>✔</td><td>✝</td>
  </tr>
</table>

 ✝ Already implemented by the base SDK but needs to be merged into this fork. Since I don't use this content sources I'm not interessted in doing that now.

#### Players

<table>
  <tr>
    <th>Name</th><th>iOS</th><th>Mac</th><th>Implemented</th>
  </tr>
  <tr>
    <td>AVQueuePlayer</td><td>✔</td><td>✔</td><td>✔</td>
  </tr>
  <tr>
    <td>MPMusicPlayerController</td><td>✔</td><td>✘</td><td>✔</td>
  </tr>
  <tr>
    <td>SFBAudioEngine</td><td>✔</td><td>✔</td><td>✝</td>
  </tr>
  <tr>
    <td>Spotify SDK</td><td>✔</td><td>✔</td><td>✝</td>
  </tr>
</table>

✝ Already implemented by the base SDK but needs to be merged into this fork. Since I don't use this players I'm not interessted in doing that now.


### License

This SNRMusicKit project by [Indragie Karunaratne](https://github.com/indragiek) which is the base of this project is licensed under the [BSD License](http://opensource.org/licenses/bsd-license.php). All additions made by this fork are under the [MIT License](https://raw.github.com/hohl/SonoraMusicKit/master/LICENSE).