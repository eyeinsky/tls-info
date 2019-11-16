module Main where

import Prelude
import Data.Maybe
import Data.IORef
import Data.Default

import qualified Network.HTTP.Types as Http
import qualified Network.Wai as Wai
import Network.Wai.Handler.Warp as Warp
import qualified Network.Wai.Handler.WarpTLS as WarpTLS

import qualified Network.TLS
import Data.X509 as X509

import Control.Concurrent
import Control.Monad


main :: IO ()
main = WarpTLS.runTLS tlsSettings' Warp.defaultSettings handler

handler :: WarpTLS.TLSAppInfo -> Wai.Application
handler tlsInfo req resp = do
  let ioRef = fromJust tlsInfo -- Always Just when using runTLS
  maybeChain <- readIORef ioRef
  case maybeChain of
    Just (X509.CertificateChain (cert : _)) -> do
      putStrLn "Got cert:"
      print cert
    _ -> do
      putStrLn "This shouldn't happen because client cert is required"

  resp $ Wai.responseLBS Http.status200 [] "Hello World"

tlsSettings' :: WarpTLS.TLSSettings
tlsSettings' = (WarpTLS.tlsSettings "cert_server_cert.pem" "cert_server_key.pem")
  { WarpTLS.tlsWantClientCert = True
  , WarpTLS.tlsServerHooks = def
    { Network.TLS.onClientCertificate = \ chain ioref -> do
        atomicWriteIORef ioref $ Just chain
        return Network.TLS.CertificateUsageAccept
    }
  }

-- type TLSAppInfo = Maybe (IORef (Maybe X509.CertificateChain))
