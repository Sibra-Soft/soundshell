using NAudio.Wave;
using Terminal.Gui;

namespace SoundShell {  
    public partial class Main {
        WaveOutEvent? outputDevice = null;
        AudioFileReader? audioFile = null;

        private void PlayMedia(string file)
        {
            outputDevice?.Stop();
            outputDevice?.Dispose();
            audioFile?.Dispose();

            audioFile = new AudioFileReader(file);
            outputDevice = new WaveOutEvent();

            var fileInfo = new FileInfo(audioFile.FileName);

            labelFilename.Text = fileInfo.Name;
            labelFileLength.Text = string.Format("{0} bytes ({1})", audioFile.Length, audioFile.TotalTime.ToString(@"mm\:ss"));
            labelBitrate.Text = string.Format("{0} kBits", audioFile.WaveFormat.BitsPerSample);
            labelSmaplerate.Text = string.Format("{0}hz", audioFile.WaveFormat.SampleRate);
            labelChannel.Text = (audioFile.WaveFormat.Channels > 1 ? "Stereo" : "Mono");
              
            outputDevice.Init(audioFile);
            outputDevice.Play();
        }

        public Main() {
            InitializeComponent();

            Application.MainLoop.AddTimeout(TimeSpan.FromMicroseconds(500), _ =>
            {
                if(outputDevice != null)
                {
                    if (outputDevice.PlaybackState == PlaybackState.Playing)
                    {
                        double seconds = audioFile.CurrentTime.TotalSeconds;
                        double framesPerSecond = audioFile.WaveFormat.SampleRate / 1152.0;

                        int frame = (int)(seconds * framesPerSecond);

                        labelCurrentFrame.Text = frame.ToString();
                        labelCurrentFrame.SetNeedsDisplay();

                        labelCurrentMediaTime.Text = string.Format("{0} / {1}", audioFile.CurrentTime.ToString(@"mm\:ss"), audioFile.TotalTime.ToString(@"mm\:ss"));
                    }
                }

                return true;
            });

            this.KeyDown += Main_KeyDown;
        }

        private void Main_KeyDown(KeyEventEventArgs obj)
        {
            if (obj.KeyEvent.Key == Key.F2)
            {
                this.Closing += Main_Closing;
                fileDialog.Visible = true;
            }

            if(obj.KeyEvent.Key == Key.Esc)
            {
                Application.RequestStop();
            }

            if (obj.KeyEvent.Key == Key.p)
            {
                if(outputDevice.PlaybackState == PlaybackState.Paused)
                {
                    outputDevice.Play();
                }
                else
                {
                    outputDevice.Pause();
                }
            }
        }

        private void Main_Closing(ToplevelClosingEventArgs obj)
        {
            obj.Cancel = true;

            if (!this.fileDialog.Canceled)
            {
                fileDialog.Visible = false;

                PlayMedia(fileDialog.FilePath.ToString());
            }
            else
            {
                this.fileDialog.Visible = false;
            }
        }
    }
}
